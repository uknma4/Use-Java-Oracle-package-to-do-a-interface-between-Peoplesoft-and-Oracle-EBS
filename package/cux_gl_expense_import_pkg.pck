CREATE OR REPLACE PACKAGE cux_gl_expense_import_pkg IS

  --
  -- Package
  --   CUX_10_EXPENSE_IMPORT_PKG
  -- Purpose
  --   ����ƽ̨ --�ճ����õ�������
  -- Popi Classification
  --  
  -- History
  --   2009-10-20    eddie  Created
  -- Notes
  --
  p_application_id NUMBER := 101;

  p_books_id NUMBER := 2021;

  p_user_id NUMBER := fnd_profile.value('USER_ID');

  p_chart_of_accounts_id NUMBER := 50388;

  p_user_je_category_name1 VARCHAR2(20) := '����ƾ֤';

  p_user_je_source_name VARCHAR2(20) := 'PSϵͳ'; --'���ñ���';
  --�����ʽ�ƻ�
  TYPE r_je_batch IS RECORD(
    je_batch_id   NUMBER,
    je_batch_name VARCHAR2(240),
    status        VARCHAR2(30));

  TYPE t_je_batch IS TABLE OF r_je_batch INDEX BY BINARY_INTEGER;

 /* TYPE r_je_header IS RECORD(
    je_header_id       NUMBER,
    external_reference VARCHAR2(80),
    attribute6         VARCHAR2(150));

  TYPE t_je_header IS TABLE OF r_je_header INDEX BY BINARY_INTEGER;*/

  --��ȡ��֯��˾����
  FUNCTION get_org_code1(p_org_id IN NUMBER) RETURN VARCHAR2;

  PROCEDURE pre_import1(p_req_id     IN NUMBER,
                        x_return_msg OUT NOCOPY VARCHAR2);

  --��ȡ����ڼ�
  PROCEDURE get_gl_period(p_account_date IN DATE,
                          p_period       OUT VARCHAR2,
                          p_return       OUT VARCHAR2);

  --------------------------------------------------------
  --��ȡ�ռ���ƾ֤���
  FUNCTION get_voch_number(p_je_header_id IN NUMBER) RETURN VARCHAR2;

  --�����Ʊ����Ƶ���
  /*PROCEDURE p_Update_Create_By(p_Ae_Header_Id IN NUMBER,
                                 p_Je_Header_Id IN NUMBER,
                                 p_Return_Text  OUT VARCHAR2);
  */

  --����ccid
  FUNCTION create_ccid(p_concatenated_segments IN VARCHAR2) RETURN VARCHAR2;

  --�����ռ��� 
  PROCEDURE p_gl_import_p(p_req_id      IN NUMBER,
                          p_org_id      IN NUMBER,
                          p_period_name IN VARCHAR2,
                          p_group_id    IN OUT NUMBER,
                          p_return_text OUT VARCHAR2);

  --���ݲ���ӿڱ�
  PROCEDURE insert_data_p(p_account_type          IN VARCHAR2,
                          p_amount                IN NUMBER,
                          p_group_id              IN NUMBER,
                          p_comb_id               IN NUMBER,
                          p_batch_name            IN VARCHAR2,
                          p_name                  IN VARCHAR2,
                          p_period                IN VARCHAR2,
                          p_user_je_category_name IN VARCHAR2,
                          p_account_date          IN DATE,
                          p_header_descp          IN VARCHAR2,
                          p_line_descp            IN VARCHAR2,
                          p_ref1                  IN VARCHAR2,
                          p_ref2                  IN VARCHAR2,
                          p_ref3                  IN VARCHAR2,
                          p_ref4                  IN VARCHAR2,
                          p_ref5                  IN VARCHAR2,
                          p_ref6                  IN VARCHAR2,
                          p_ref7                  IN VARCHAR2,
                          p_ae_header_id          IN NUMBER,
                          p_ae_line_id            IN NUMBER,
                          p_req_id                IN NUMBER,
                          p_return                OUT VARCHAR2);

  --���µ������ֶ�
  PROCEDURE update_attribute_p(p_je_header_id IN NUMBER,
                               p_je_line_num  IN NUMBER,
                               --     p_ae_header_id IN NUMBER,
                               p_ae_line_id IN NUMBER,
                               p_return     OUT VARCHAR2);

  --д���ռ��ʵ����������ɵĴ�����Ϣ
  PROCEDURE write_interface_report_p(p_group_id    IN NUMBER,
                                     p_return_text OUT VARCHAR2);

  --��ȡƾ֤���
  FUNCTION get_je_category_f(p_user_category_name IN VARCHAR2)
    RETURN VARCHAR2;

  --================================================
  -- Procedure
  --   CUX_10_fetch_parameter_p
  -- Purpose
  --   �ύ����
  -- History
  --   2009-10-26  eddie    Created
  -- Arguments
  --   p_req_id ����ID��SEQUENCE ID
  --   p_cap_id ����ƽ̨֧������ID
  -- Example
  --
  -- Notes
  --================================================
  PROCEDURE p_submit_req_p(errbuf   OUT VARCHAR2,
                           retcode  OUT NUMBER,
                           p_req_id IN NUMBER,
                           p_source IN VARCHAR2,
                           --   p_cap_type IN VARCHAR2, --BXD,YGJK
                           p_org_id IN NUMBER,
                           --        p_Sec_Org_Code IN VARCHAR2,
                           p_period_name IN VARCHAR2);

  --================================================
  -- Procedure
  --   payment_Import_Report
  -- Purpose
  --   ��������
  -- History
  --   2009-10-26  eddie    Created
  -- Arguments
  --   p_Import_Req_Id ����ID��SEQUENCE ID
  -- Example
  --
  -- Notes
  --================================================

  FUNCTION get_output_file(p_request_id IN NUMBER) RETURN VARCHAR2;

  FUNCTION get_account_code(p_ccid IN NUMBER) RETURN VARCHAR2;

  /*
    FUNCTION Get_Pay_Create_By(p_Apply_Id    IN NUMBER,
                               p_Type        IN VARCHAR2,
                               p_Return_Type IN VARCHAR2 DEFAULT 'NAME',
                               p_category    in varchar2 default null)
      RETURN VARCHAR2;
  */
  ------------�ɹ��������µ����ֶΡ������˵���Ϣ
  PROCEDURE post_import(p_je_category IN VARCHAR2,
                        p_period_name IN VARCHAR2,
                        p_req_id      IN NUMBER,
                        p_return1     OUT VARCHAR2,
                        p_return2     OUT VARCHAR2,
                        p_je_batch_id IN NUMBER DEFAULT NULL);

  FUNCTION get_je_header_id(p_ae_header_id IN NUMBER) RETURN VARCHAR2;

  ------------------------------------------------------------

  /*  FUNCTION trace_request(p_request_id  number,P_BAT_ID  NUMBER)
  RETURN VARCHAR2 ; --��������*/

  PROCEDURE p_gl_batch_post(p_batch_id    IN NUMBER,
                            x_return_text OUT VARCHAR2);

  FUNCTION get_je_batch_by_ae(p_ae_header_id IN NUMBER, p_type IN VARCHAR2)
    RETURN VARCHAR2;

  PROCEDURE log(p_msg IN VARCHAR2);

  PROCEDURE jv_post_wait(p_period_name IN VARCHAR2,
                         p_request_id  IN NUMBER,
                         p_je_batch_id IN NUMBER);

END cux_gl_expense_import_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_gl_expense_import_pkg IS

  -------------------------------

  --------------------------------------------------------
  --��ȡ��֯��˾name
  FUNCTION get_org_code(p_org_id IN NUMBER) RETURN VARCHAR2 AS
    v_comp        VARCHAR2(100);
    v_flex_set_id NUMBER;
  BEGIN
    SELECT NAME
      INTO v_comp
      FROM hr_operating_units hou
     WHERE hou.organization_id = p_org_id;
    RETURN v_comp;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  --------------------------------------------------------
  --��ȡ��֯��˾����
  FUNCTION get_org_code1(p_org_id IN NUMBER) RETURN VARCHAR2 AS
    v_comp VARCHAR2(100);
  BEGIN
    SELECT hou.short_code
      INTO v_comp
      FROM hr_operating_units hou
     WHERE hou.organization_id = p_org_id;
    RETURN v_comp;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  --------------------------------------------------------

  --------------------------------------------------------

  --------------------------------------------------------
  --��ȡ�ռ���ƾ֤���
  FUNCTION get_voch_number(p_je_header_id IN NUMBER) RETURN VARCHAR2 AS
    v_number VARCHAR2(2000);
  BEGIN
    SELECT a.external_reference
      INTO v_number
      FROM gl_je_headers a
     WHERE a.je_header_id = p_je_header_id;
    RETURN v_number;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  ---------------------------------------------------------
  --����״̬��Ϣ
  --�˳�����Ҫ����ÿһ������ʱ����״̬��Ϣ�������ڵ���ɹ�ʱʹ��
  PROCEDURE update_status_p(p_req_id       IN NUMBER,
                            p_ae_header_id IN NUMBER,
                            p_ae_line_id   IN NUMBER,
                            p_je_header_id IN NUMBER,
                            p_je_line_num  IN NUMBER,
                            p_status       IN VARCHAR2,
                            p_meg          IN VARCHAR2) IS
    -- PRAGMA AUTONOMOUS_TRANSACTION;
    /* v_Source_Table        VARCHAR2(240);
    v_Source_Id           NUMBER;*/
    v_line_type           VARCHAR2(20);
    v_ae_header_id        NUMBER;
    v_header_source_table VARCHAR2(240);
    v_line_source_id      NUMBER;
    v_line_source_table   VARCHAR2(240);
    v_line_id             NUMBER;
    v_count               NUMBER;
    v_sum                 NUMBER;
  BEGIN
  
    --������ʱ���Gl_Je_Header_Id��Gl_Je_Line_Num,״̬ΪP_startus
    UPDATE cux.cux_gl_import_lines_all ccp
       SET ccp.status = p_status
     WHERE ccp.req_id = p_req_id;
    cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.UPDATE_STATUS_P',
                           p_error_message => 'p_Status' || p_status ||
                                              'p_Ae_Header_Id' ||
                                              p_ae_header_id);
    -- ����AEͷ���ѹ���ΪY��״̬Ϊ����p_Status
    UPDATE cux.cux_ae_headers_all cc1
       SET cc1.transfer_flag = 'Y', cc1.transfer_error_code = p_status
     WHERE cc1.ae_header_id = p_ae_header_id;
    --ֻ�б��������ڸ�ծ�ʻ��ϲ���֧������ĵ��ݲ��ܺϲ���ծ�ʻ���
    IF v_line_type = 'LIABILITY' AND
       v_header_source_table = 'CUX_EXPENSE_HEADERS_ALL' THEN
      UPDATE cux.cux_ae_lines_all cc2
         SET cc2.return_source_id     = p_je_header_id,
             cc2.return_source_table  = 'GL_JE_LINES',
             cc2.return_source_number = p_je_line_num
       WHERE cc2.ae_header_id = v_ae_header_id
         AND cc2.ae_line_type_code = 'LIABILITY';
    ELSE
      UPDATE cux.cux_ae_lines_all cc2
         SET cc2.return_source_id     = p_je_header_id,
             cc2.return_source_table  = 'GL_JE_LINES',
             cc2.return_source_number = p_je_line_num
       WHERE cc2.ae_line_id = p_ae_line_id;
    END IF;
    --add by eddie 20100727
    --������и�ծ�ʻ��ж����ϲ�ʱ����ծ��δ��дֵ��BUG
    --�ų������������Ǹ�ծ�е�����
    BEGIN
      SELECT SUM(nvl(a.accounted_dr, 0) - nvl(a.accounted_cr, 0))
        INTO v_sum
        FROM cux.cux_ae_lines_all a
       WHERE a.ae_header_id = p_ae_header_id
         AND a.ae_line_type_code = 'LIABILITY'
         AND EXISTS (SELECT 1
                FROM cux.cux_ae_lines_all x
               WHERE x.ae_header_id = a.ae_header_id
                 AND x.ae_line_type_code != 'LIABILITY');
    EXCEPTION
      WHEN OTHERS THEN
        v_sum := 0;
    END;
    IF v_sum = 0 THEN
      UPDATE cux.cux_ae_lines_all cc2
         SET cc2.return_source_id     = -1,
             cc2.return_source_table  = 'GL_JE_LINES',
             cc2.return_source_number = NULL
       WHERE cc2.ae_header_id = p_ae_header_id
         AND cc2.ae_line_type_code = 'LIABILITY'
         AND cc2.return_source_id IS NULL
         AND EXISTS (SELECT 1
                FROM cux.cux_ae_lines_all x
               WHERE x.ae_header_id = cc2.ae_header_id
                 AND x.ae_line_type_code != 'LIABILITY');
    
    END IF;
    --end added
    --����Return_Source_Id��Return_Source_Table
  
  EXCEPTION
    WHEN OTHERS THEN
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.UPDATE_STATUS_P',
                             p_error_message => substr(SQLERRM, 1, 200));
  END update_status_p;

  -------------------------------------

  -------------------------------------

  ---------------------------------------------------------

  ---------------------------------------------------------
  --ɾ���ռ�����Ϣ
  PROCEDURE delete_gl_batch(p_batch_id NUMBER) IS
  BEGIN
    DELETE FROM gl_je_lines gjl
     WHERE EXISTS (SELECT 1
              FROM gl_je_headers gjh
             WHERE gjh.je_header_id = gjl.je_header_id
               AND gjh.je_batch_id = p_batch_id);
    DELETE FROM gl_import_references a
     WHERE EXISTS (SELECT 1
              FROM gl_je_headers gjh
             WHERE gjh.je_header_id = a.je_header_id
               AND gjh.je_batch_id = p_batch_id);
    DELETE FROM gl_je_headers WHERE je_batch_id = p_batch_id;
    DELETE FROM gl_je_batches WHERE je_batch_id = p_batch_id;
  EXCEPTION
    WHEN OTHERS THEN
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.DELETE_GL_BATCH',
                             p_error_message => substr(SQLERRM, 1, 200));
  END;

  -----------------------------------------------------------
  --���GL_INTERFACE ��Ϣ
  PROCEDURE delete_gl_interface(p_req_id NUMBER) IS
  BEGIN
    cux_gl_expense_import_pkg.log('����ɾGL INTERFACE ����');
    DELETE FROM gl_interface t
     WHERE t.group_id = to_char(p_req_id)
          --  AND t.user_je_category_name = p_user_je_category_name1
       AND t.user_je_source_name = p_user_je_source_name;
  EXCEPTION
    WHEN OTHERS THEN
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.DELETE_GL_INTERFACE',
                             p_error_message => substr(SQLERRM, 1, 200));
  END;

  ---------------------------------------------------------
  --��ȡ����ڼ�
  PROCEDURE get_gl_period(p_account_date IN DATE,
                          p_period       OUT VARCHAR2,
                          p_return       OUT VARCHAR2) IS
    v_period_name VARCHAR2(20);
  BEGIN
    SELECT t.period_name
      INTO v_period_name
      FROM gl_period_statuses t
     WHERE t.application_id = p_application_id
       AND t.set_of_books_id = p_books_id
       AND trunc(p_account_date) BETWEEN t.start_date AND t.end_date
       AND rownum = 1;
    IF v_period_name IS NOT NULL THEN
      p_return := NULL;
      p_period := v_period_name;
    ELSE
      p_return := '��ȡ����ڼ�ʧ�ܣ�Account_Date=' ||
                  to_char(p_account_date, 'yyyy-mm-dd');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      p_return := substr(SQLERRM, 1, 200);
  END;

  ---------------------------------------------------
  --��ȡ�ռ�����Դ����
  PROCEDURE get_je_source(p_user_source_name IN VARCHAR2,
                          p_source_name      OUT VARCHAR2,
                          p_return_text      OUT VARCHAR2) IS
  BEGIN
    SELECT t.je_source_name
      INTO p_source_name
      FROM gl_je_sources t
     WHERE t.user_je_source_name = p_user_source_name;
  EXCEPTION
    WHEN OTHERS THEN
      p_return_text := p_return_text || '��ȡ�ռ�����Դʧ�ܣ� ��Դ = ' ||
                       p_user_source_name;
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.F_GET_JE_SOURCE',
                             p_error_message => '��ȡ�ռ�����Դʧ�ܣ� ��Դ = ' ||
                                                p_user_source_name);
  END;

  ---------------------------------------------------
  --��ȡ��������
  PROCEDURE get_dept_name(p_dept_no     IN NUMBER,
                          p_dept_name   OUT VARCHAR2,
                          p_return_text OUT VARCHAR2) IS
  BEGIN
    SELECT t.descr
      INTO p_dept_name
      FROM cux.cux_mdm_dept_info t
     WHERE deptid = p_dept_no;
  EXCEPTION
    WHEN OTHERS THEN
      p_return_text := p_return_text || '��ȡ��������ʧ�ܣ� ���ű�� = ' || p_dept_no;
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.F_GET_JE_SOURCE',
                             p_error_message => '��ȡ��������ʧ�ܣ� ���ű�� = ' ||
                                                p_dept_no);
  END;

  ---------------------------------------------------
  --��ȡ�û���Ա������
  FUNCTION get_user_name(p_user_id IN NUMBER, p_enter_date IN DATE)
    RETURN VARCHAR2 IS
    v_user_name VARCHAR2(200);
  BEGIN
    SELECT ppf.full_name
      INTO v_user_name
      FROM fnd_user fu, per_all_people_f ppf
     WHERE fu.employee_id = ppf.person_id
       AND fu.user_id = p_user_id
       AND nvl(p_enter_date, SYSDATE) BETWEEN ppf.effective_start_date AND
           ppf.effective_end_date;
    RETURN v_user_name;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        SELECT ppf.full_name
          INTO v_user_name
          FROM fnd_user fu, per_all_people_f ppf
         WHERE fu.employee_id = ppf.person_id
           AND fu.user_id = p_user_id
           AND rownum = 1;
        RETURN v_user_name;
      EXCEPTION
        WHEN OTHERS THEN
          RETURN NULL;
      END;
  END;

  ------------------------------------------------------------
  --��ȡ�ռ������
  PROCEDURE get_je_category(p_user_category_name IN VARCHAR2,
                            p_catogory_name      OUT VARCHAR2,
                            p_return_text        OUT VARCHAR2) IS
  BEGIN
    SELECT b.user_je_category_name
      INTO p_catogory_name
      FROM gl_je_categories b
     WHERE b.je_category_name = p_user_category_name;
  EXCEPTION
    WHEN OTHERS THEN
      p_return_text := p_return_text || '��ȡ�ռ�������ʧ�ܣ� ���� = ' ||
                       p_user_category_name;
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_SUBMIT_REQ_P',
                             p_error_message => '��ȡ�ռ�������ʧ�ܣ� ���� = ' ||
                                                p_user_category_name);
  END;

  ------------------------------------------------------------
  --��ȡ�ռ������
  FUNCTION get_je_category_f(p_user_category_name IN VARCHAR2)
    RETURN VARCHAR2 IS
    p_catogory_name VARCHAR2(500);
  BEGIN
    SELECT b.user_je_category_name
      INTO p_catogory_name
      FROM gl_je_categories b
     WHERE b.je_category_name = p_user_category_name;
    RETURN p_catogory_name;
  EXCEPTION
    WHEN OTHERS THEN
      p_catogory_name := '';
  END;

  ------------------------------------------------------------
  --��ȡ��ծ�ʻ��ϼ�ֵ--���ڷ��ñ�������֧�������
  FUNCTION get_liability_amount(p_ae_header_id IN NUMBER,
                                p_ae_line_id   IN NUMBER) RETURN NUMBER IS
    v_amount NUMBER;
  BEGIN
    SELECT SUM(nvl(a.accounted_cr, 0) - nvl(a.accounted_dr, 0))
      INTO v_amount
      FROM cux.cux_ae_lines_all a
     WHERE a.ae_line_id != p_ae_line_id
       AND a.ae_line_type_code = 'LIABILITY'
       AND a.ae_header_id = p_ae_header_id;
    RETURN nvl(v_amount, 0);
  EXCEPTION
    WHEN OTHERS THEN
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.GET_LIABILITY_AMOUNT',
                             p_error_message => SQLERRM);
      RETURN 0;
  END;

  ------------------------------------------------------------

  --   Log
  --==========================================================
  PROCEDURE log(p_msg IN VARCHAR2) IS
  BEGIN
    fnd_file.put_line(fnd_file.log, p_msg);
  END log;

  ------------------------------------------------------------
  --==========================================================
  --   Output
  --==========================================================
  PROCEDURE output(p_msg IN VARCHAR2) IS
  BEGIN
    fnd_file.put_line(fnd_file.output, p_msg);
  END output;

  ---------------------------------------------------------
  --��ȡ�ռ�������
  PROCEDURE get_je_batch(p_ref10  IN VARCHAR2,
                         p_period IN VARCHAR2,
                         --p_Batch_Name  OUT VARCHAR2,
                         --p_Gl_Date     OUT VARCHAR2,
                         --p_Batch_Id    OUT NUMBER,
                         x_t_je_batch OUT t_je_batch,
                         --updated by eddie 2011-04-14
                         p_return_text OUT VARCHAR2) IS
    v_je_source_name   VARCHAR2(200);
    v_return           VARCHAR2(2000);
    v_je_category_name VARCHAR2(200);
    CURSOR c_batch IS
      SELECT DISTINCT gjb.name,
                      --To_Char(Gjh.Default_Effective_Date, 'yyyy-mm-dd'),
                      to_char(gjb.default_effective_date, 'yyyy-mm-dd'),
                      gjb.je_batch_id,
                      substr(gjb.name,
                             instr(gjb.name, '-', 1, 1) + 1,
                             instr(gjb.name, '-', 1, 2) -
                             instr(gjb.name, '-', 1, 1) - 1) document_type,
                      (SELECT ffv.attribute4
                         FROM fnd_flex_values_vl  ffv,
                              fnd_flex_value_sets ffvs
                        WHERE ffv.flex_value_set_id = ffvs.flex_value_set_id
                          AND ffvs.flex_value_set_name =
                              'CUX_DOCUMENTS_TYPE'
                          AND ffv.description =
                              substr(gjb.name,
                                     instr(gjb.name, '-', 1, 1) + 1,
                                     instr(gjb.name, '-', 1, 2) -
                                     instr(gjb.name, '-', 1, 1) - 1)
                          AND rownum < 2) document_type_seq
        FROM gl_je_batches gjb, gl_je_headers gjh, gl_je_lines gjl
       WHERE gjl.je_header_id = gjh.je_header_id
         AND gjh.je_batch_id = gjb.je_batch_id
         AND gjh.je_source = v_je_source_name
         AND gjh.je_category = v_je_category_name
         AND gjh.period_name = p_period
         AND gjl.reference_10 = p_ref10
      --AND Rownum = 1
       ORDER BY document_type_seq;
    l_total_count NUMBER := 0;
    l_error_count NUMBER := 0;
  BEGIN
    --Get_Gl_Period(p_Accounting_Date, v_Period_Name, v_Return);
    IF v_return IS NOT NULL THEN
      p_return_text := p_return_text || v_return;
    END IF;
    get_je_source(p_user_je_source_name, v_je_source_name, v_return);
    p_return_text := p_return_text || v_return;
    get_je_category(p_user_je_category_name1, v_je_category_name, v_return);
    p_return_text := p_return_text || v_return;
    FOR r_batch IN c_batch LOOP
      BEGIN
        l_total_count := l_total_count + 1;
        x_t_je_batch(l_total_count).je_batch_id := r_batch.je_batch_id;
        x_t_je_batch(l_total_count).je_batch_name := r_batch.name;
      EXCEPTION
        WHEN OTHERS THEN
          l_error_count := l_error_count + 1;
      END;
    END LOOP;
    IF l_total_count = 0 THEN
      p_return_text := p_return_text || ' �޷��ҵ��ռ����� ';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      --p_Batch_Name  := NULL;
      --p_Gl_Date     := NULL;
      --p_Batch_Id    := NULL;
      p_return_text := p_return_text || SQLERRM;
  END;

  --�����ռ���
  ----------------------------------------------------------  
  PROCEDURE p_gl_import_p(p_req_id      IN NUMBER,
                          p_org_id      IN NUMBER,
                          p_period_name IN VARCHAR2,
                          p_group_id    IN OUT NUMBER,
                          p_return_text OUT VARCHAR2) IS
    v_same_profile VARCHAR2(20);
    v_amount       NUMBER;
    v_return       VARCHAR2(2000);
    v_return1      VARCHAR2(2000);
    v_source_table VARCHAR2(200);
    v_source_id    NUMBER;
    v_account_type VARCHAR2(10);
    --v_Header_Name     VARCHAR2(2000);
    v_batch_name            VARCHAR2(100);
    v_header_name           VARCHAR2(100); --updated by eddie 2011-05-13
    v_period_name           VARCHAR2(12);
    v_accounting_date       DATE := nvl(last_day(to_date(p_period_name,
                                                         'YYYY-MM')),
                                        SYSDATE);
    v_header_descp          VARCHAR2(240);
    v_line_descp            VARCHAR2(240);
    v_org_id                NUMBER;
    v_corp                  VARCHAR2(20);
    v_number                NUMBER;
    v_gl_name_type          VARCHAR2(80);
    v_document_type         VARCHAR2(80);
    v_user_je_category_name VARCHAR2(150);
    CURSOR c_batch_type IS
      SELECT a.period_name, a.org_id
        FROM cux.cux_gl_import_lines_all a
       WHERE a.req_id = p_req_id
         AND a.org_id = p_org_id
         AND a.status = 'V'
       GROUP BY a.period_name, a.org_id;
    CURSOR c_je_name_type(p_v_org_id NUMBER, p_v_period_name VARCHAR2) IS
      SELECT a.period_name, a.org_id, a.user_je_category_name
        FROM cux.cux_gl_import_lines_all a
       WHERE a.req_id = p_req_id
         AND a.org_id = p_v_org_id
         AND a.period_name = p_v_period_name
         AND a.status = 'V'
       GROUP BY a.period_name, a.org_id, a.user_je_category_name;
    CURSOR c_je_lines_type(p_v_org_id              NUMBER,
                           p_v_period_name         VARCHAR2,
                           p_user_je_category_name VARCHAR2) IS
      SELECT a.header_id,
             a.ccid,
             a.period_name,
             a.org_id,
             a.user_je_category_name,
             a.ccid_segment1,
             a.ccid_segment2,
             a.ps_segment2,
             a.ccid_segment3,
             a.ccid_segment4,
             a.ccid_segment5,
             a.ccid_segment6,
             a.ccid_segment7,
             a.ccid_segment8,
             a.ccid_segment9,
             a.ccid_segment10,
             a.entered_dr,
             a.entered_cr
        FROM cux.cux_ps_import_je_lines_sum a
       WHERE a.req_id = p_req_id
         AND a.org_id = p_v_org_id
         AND a.period_name = p_v_period_name
         AND a.user_je_category_name = p_user_je_category_name;
    --ѭ�������У���ȡAE_HEADER_ID
  BEGIN
    log('���뵼�ӿڱ����');
    v_org_id := p_org_id;
    v_corp   := get_org_code1(v_org_id);
    /*    BEGIN
      SELECT DISTINCT a.period_name
        INTO v_period_name
        FROM cux.cux_gl_import_lines_all a
       WHERE a.req_id = p_req_id
         AND a.org_id = p_org_id;
    EXCEPTION
      WHEN OTHERS THEN
        p_return_text := p_return_text || '��ȡ�ڼ�ʧ�ܣ����ܴ��ڶ���ڼ�';
        cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_GL_IMPORT_P',
                               p_error_message => p_return_text);
        app_exception.raise_exception;
    END;*/
    p_group_id := p_req_id || v_corp;
    FOR r_batch_type IN c_batch_type LOOP
      -- ͷ���� ��˾����+�ڼ�+ƾ֤���
      --������  ��������+��Ŀ����
      v_batch_name := get_org_code(p_org_id) ||
                      to_char(SYSDATE, 'YYYYMMDD');
      FOR r_je_name_type IN c_je_name_type(r_batch_type.org_id,
                                           r_batch_type.period_name) LOOP
        v_header_descp := get_org_code(r_je_name_type.org_id) ||
                          r_je_name_type.period_name ||
                          r_je_name_type.user_je_category_name;
        cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_GL_IMPORT_P',
                               p_error_message => v_header_descp);
        v_header_name := cux_gl_jounal_personal_pub.get_jounal_seq_number1(r_je_name_type.period_name);
        cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_GL_IMPORT_P',
                               p_error_message => v_header_name);
        FOR r_je_lines_type IN c_je_lines_type(r_je_name_type.org_id,
                                               r_je_name_type.period_name,
                                               r_je_name_type.user_je_category_name) LOOP
          v_return := NULL;
          IF nvl(r_je_lines_type.entered_dr, 0) != 0 THEN
            v_account_type := 'DR';
            v_amount       := r_je_lines_type.entered_dr;
          ELSE
            v_account_type := 'CR';
            v_amount       := r_je_lines_type.entered_cr;
          END IF;
          v_line_descp := r_je_lines_type.ps_segment2 ||
                          gl_flexfields_pkg.get_description_sql(50388,
                                                                3,
                                                                r_je_lines_type.ccid_segment3);
          get_je_category(r_je_lines_type.user_je_category_name,
                          v_user_je_category_name,
                          v_return1);
          insert_data_p(p_account_type          => v_account_type,
                        p_amount                => v_amount,
                        p_group_id              => p_group_id,
                        p_comb_id               => r_je_lines_type.ccid,
                        p_batch_name            => v_batch_name,
                        p_name                  => v_header_name,
                        p_period                => v_period_name,
                        p_user_je_category_name => v_user_je_category_name,
                        p_account_date          => v_accounting_date,
                        p_header_descp          => v_header_descp,
                        p_line_descp            => v_line_descp,
                        p_ref1                  => NULL,
                        p_ref2                  => NULL,
                        p_ref3                  => NULL,
                        p_ref4                  => to_char(p_req_id),
                        p_ref5                  => NULL,
                        p_ref6                  => NULL,
                        p_ref7                  => NULL,
                        p_ae_header_id          => NULL,
                        p_ae_line_id            => r_je_lines_type.header_id,
                        p_req_id                => p_req_id,
                        p_return                => v_return);
          p_return_text := p_return_text || v_return;
        END LOOP;
      END LOOP;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      p_return_text := p_return_text || substr(SQLERRM, 1, 200);
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_GL_IMPORT_P',
                             p_error_message => SQLERRM);
  END p_gl_import_p;

  ---------------------------------------------------------
  --�ύ�ռ�������
  PROCEDURE p_run_gl_interface(p_req_id      IN NUMBER,
                               p_group_id    IN NUMBER,
                               p_source_name IN NUMBER,
                               p_return_text OUT VARCHAR2) IS
    v_req_id         NUMBER;
    l_phase          VARCHAR2(80);
    l_status         VARCHAR2(80);
    l_dev_phase      VARCHAR2(80);
    l_dev_status     VARCHAR2(80);
    l_message        VARCHAR2(80);
    l_wait_outcome   BOOLEAN;
    v_sub_request_id NUMBER;
    i                NUMBER := 0;
  BEGIN
    v_req_id := fnd_request.submit_request('SQLGL', --Ӧ��ģ���������д,������System Administrator -> Application -> Register����鵽
                                           'GLLEZLSRS', --Ӧ�ó����������д Application -> Concurrent -> Program
                                           '',
                                           '',
                                           FALSE, --Ĭ��Ϊ FALSE
                                           fnd_profile.value('GL_ACCESS_SET_ID'),
                                           p_source_name,
                                           2021,
                                           p_group_id,
                                           'N',
                                           'N',
                                           'N');
    IF v_req_id > 0 THEN
      COMMIT;
      l_wait_outcome := fnd_concurrent.wait_for_request(request_id => v_req_id,
                                                        INTERVAL   => 10,
                                                        phase      => l_phase,
                                                        status     => l_status,
                                                        dev_phase  => l_dev_phase,
                                                        dev_status => l_dev_status,
                                                        message    => l_message);
      IF upper(l_dev_phase) = 'COMPLETE' AND upper(l_dev_status) = 'NORMAL' THEN
        BEGIN
          -- p_return_text := NULL;
          LOOP
            BEGIN
              SELECT t.request_id
                INTO v_sub_request_id
                FROM applsys.fnd_concurrent_requests t
               WHERE t.parent_request_id = v_req_id
                 AND rownum = 1;
            EXCEPTION
              WHEN OTHERS THEN
                v_sub_request_id := 0;
            END;
            IF v_sub_request_id > 0 THEN
              EXIT;
            END IF;
            IF i >= 12 THEN
              EXIT;
            END IF;
            cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_RUN_GL_INTERFACE',
                                   p_error_message => '�ȴ�����������' || i);
            i := i + 1;
            dbms_lock.sleep(10);
          END LOOP;
          --end edit;
          -------------------------------------
          IF v_sub_request_id > 0 THEN
            log('������ID' || v_sub_request_id);
            l_wait_outcome := fnd_concurrent.wait_for_request(request_id => v_sub_request_id,
                                                              INTERVAL   => 10,
                                                              phase      => l_phase,
                                                              status     => l_status,
                                                              dev_phase  => l_dev_phase,
                                                              dev_status => l_dev_status,
                                                              message    => l_message);
            IF upper(l_dev_phase) = 'COMPLETE' AND
               upper(l_dev_status) = 'NORMAL' THEN
              BEGIN
                p_return_text := NULL;
              END;
            ELSE
              delete_gl_interface(p_group_id);
              update_status_p((p_req_id),
                              '',
                              '',
                              '',
                              '',
                              'E',
                              '���� ' || substr(SQLERRM, 1, 200));
              COMMIT;
              p_return_text := '�ύ�ռ����ӵ�������ʧ�ܣ�';
            END IF;
          ELSE
            p_return_text := '�ύ�ռ��ʵ�������ʧ�ܣ�' || v_req_id || '������IDû���ҵ�!';
          END IF;
        END;
      ELSE
        p_return_text := '�ύ�ռ��ʵ�������ʧ�ܣ�';
      END IF;
    ELSE
      p_return_text := '�ύ�ռ��ʵ�������ʧ�ܣ�';
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_RUN_GL_INTERFACE',
                             p_error_message => '�ύ�ռ��ʵ�������ʧ��');
      --   ROLLBACK;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      p_return_text := p_return_text || '�ύ�ռ��ʵ�������ʧ��' || SQLERRM;
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.P_RUN_GL_INTERFACE',
                             p_error_message => '�ύ�ռ��ʵ�������ʧ��' || SQLERRM);
  END p_run_gl_interface;

  --------------------------------------------------------
  --����ӿڱ�����
  PROCEDURE insert_data_p(p_account_type          IN VARCHAR2,
                          p_amount                IN NUMBER,
                          p_group_id              IN NUMBER,
                          p_comb_id               IN NUMBER,
                          p_batch_name            IN VARCHAR2,
                          p_name                  IN VARCHAR2,
                          p_period                IN VARCHAR2,
                          p_user_je_category_name IN VARCHAR2,
                          p_account_date          IN DATE,
                          p_header_descp          IN VARCHAR2,
                          p_line_descp            IN VARCHAR2,
                          p_ref1                  IN VARCHAR2,
                          p_ref2                  IN VARCHAR2,
                          p_ref3                  IN VARCHAR2,
                          p_ref4                  IN VARCHAR2,
                          p_ref5                  IN VARCHAR2,
                          p_ref6                  IN VARCHAR2,
                          p_ref7                  IN VARCHAR2,
                          p_ae_header_id          IN NUMBER,
                          p_ae_line_id            IN NUMBER,
                          p_req_id                IN NUMBER,
                          p_return                OUT VARCHAR2) IS
    v_status                  VARCHAR2(20) := 'NEW';
    v_currency_code           VARCHAR2(20) := 'CNY';
    v_user_id                 NUMBER := nvl(fnd_profile.value('USER_ID'),
                                            -1);
    v_actual_flag             VARCHAR2(20) := 'A';
    v_cap_source_table        VARCHAR2(200);
    v_cap_source_id           NUMBER;
    v_cap_header_source_table VARCHAR2(200);
    v_cap_header_source_id    NUMBER;
  BEGIN
    --log('�������ӿڱ�insert ����');
    INSERT INTO gl_interface
      (status,
       ledger_id,
       set_of_books_id,
       accounting_date,
       currency_code,
       date_created,
       created_by,
       actual_flag,
       user_je_category_name,
       user_je_source_name,
       entered_dr,
       entered_cr,
       accounted_dr,
       accounted_cr,
       period_name,
       chart_of_accounts_id,
       code_combination_id,
       group_id,
       attribute11,
       reference1,
       reference2,
       reference4,
       reference5,
       reference10,
       reference21,
       reference22,
       reference23,
       reference24,
       reference25,
       reference26,
       reference27,
       reference28,
       reference29,
       reference30)
    VALUES
      (v_status,
       p_books_id,
       p_books_id,
       p_account_date, --SYSDATE, --v_Accounting_Date,
       v_currency_code,
       SYSDATE,
       v_user_id,
       v_actual_flag,
       p_user_je_category_name,
       p_user_je_source_name,
       decode(p_account_type, 'DR', trunc(p_amount, 2), NULL),
       decode(p_account_type, 'DR', NULL, trunc(p_amount, 2)),
       decode(p_account_type, 'DR', trunc(p_amount, 2), NULL),
       decode(p_account_type, 'DR', NULL, trunc(p_amount, 2)),
       p_period,
       p_chart_of_accounts_id,
       p_comb_id,
       p_group_id,
       fnd_profile.value('CUX_SECU_SAME_COMPANY_CODE'),
       p_batch_name,
       p_batch_name,
       p_name,
       p_header_descp,
       p_line_descp,
       p_ref1,
       p_ref2,
       p_req_id,
       p_ae_line_id, --p_Ref4,HEADER Source_Table
       NULL, --p_Ref5, HEADER Source_id
       NULL, --p_Ref6,      LINE  Source_Table
       NULL, --p_Ref7,         LINE  Source_Id
       NULL,
       NULL,
       NULL);
  EXCEPTION
    WHEN OTHERS THEN
      p_return := p_return || substr(SQLERRM, 1, 200);
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.INSERT_DATA_P',
                             p_error_message => '���ݲ���ӿڱ�ʧ�ܣ�' ||
                                                substr(SQLERRM, 1, 200));
  END insert_data_p;

  -----------------------------------------------------------
  --���µ�������Ϣ
  PROCEDURE update_attribute_p(p_je_header_id IN NUMBER,
                               p_je_line_num  IN NUMBER,
                               p_ae_line_id   IN NUMBER,
                               p_return       OUT VARCHAR2) IS
    v_attribute7       VARCHAR2(200); --�ֽ���������
    v_header_source_id NUMBER;
  BEGIN
    SELECT gjl.reference_4
      INTO v_header_source_id
      FROM gl_je_headers gjh, gl_je_lines gjl
     WHERE gjh.je_header_id = p_je_header_id
       AND gjl.je_line_num = p_je_line_num
       AND gjh.je_header_id = gjl.je_header_id
       AND gjl.je_line_num = p_je_line_num;
    --�����ռ�����Attributeֵ
    SELECT a.location_code
      INTO v_attribute7
      FROM cux.cux_ps_import_je_lines_sum t, hr_locations_all a
     WHERE t.header_id = v_header_source_id
       AND a.description = t.city_no
       AND rownum = 1;
    UPDATE gl_je_lines gjl
       SET attribute7 = v_attribute7
     WHERE gjl.je_header_id = p_je_header_id
       AND gjl.je_line_num = p_je_line_num;
  EXCEPTION
    WHEN OTHERS THEN
      p_return := substr(SQLERRM, 1, 200);
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.UPDATE_ATTRIBUTE_P',
                             p_error_message => '���µ������ֶ�ʧ�ܣ�' ||
                                                substr(SQLERRM, 1, 200) ||
                                                'P_AE_HEADER_ID=' ||
                                                'P_AE_LINE_ID=' ||
                                                p_ae_line_id);
  END update_attribute_p;

  --------------------------------------
  --��ȡ�ռ��ʵ���Ĵ�����Ϣ
  PROCEDURE write_interface_report_p(p_group_id    IN NUMBER,
                                     p_return_text OUT VARCHAR2) IS
    v_count  NUMBER := 0;
    v_pos    NUMBER;
    v_string VARCHAR2(200);
    v_status VARCHAR2(200);
    v_return VARCHAR2(2000);
  BEGIN
    FOR cux_temp IN (SELECT DISTINCT gi.status,
                                     gi.reference28,
                                     gi.reference29,
                                     gi.reference24
                       FROM gl_interface gi
                      WHERE gi.group_id = p_group_id) LOOP
      v_return := NULL;
      v_status := cux_temp.status;
      FOR v_pos IN 1 .. 10 LOOP
        v_status := substr(v_status, v_count + 1);
        v_count  := instr(v_status, ',');
        IF v_count = 0 THEN
          v_string := v_status;
        ELSE
          v_string := substr(v_status, 1, v_count - 1);
        END IF;
        IF v_string = 'EP01' THEN
          v_return := '�ռ��ʵ������  �����ڲ����κδ򿪵Ļ�����������ڼ��ڡ�';
        ELSIF v_string = 'EU02' THEN
          v_return := v_return || '���ռ��ʷ�¼��ƽ�⣬�����ڴ������в������ݼǹ��ʡ�';
        ELSIF v_string = 'EF04' THEN
          v_return := v_return || '������Ч�Ļ�ƿ�Ŀ�����򡣼�����Ľ�����֤����Ͷ�ֵ��';
        ELSIF v_string = 'EF05' THEN
          v_return := v_return || '�����ھ��д˴�����ϱ�ʶ�Ļ�ƿ�Ŀ������';
        ELSIF v_string LIKE 'E%' THEN
          v_return := v_return || v_string;
        END IF;
        EXIT WHEN v_count = 0;
      END LOOP;
      UPDATE cux.cux_gl_import_lines_all ab
         SET ab.msg = ab.msg || v_return
       WHERE ab.req_id = to_number(cux_temp.reference24)
      --     AND ab.ae_header_id = to_number(cux_temp.reference28)
      --AND Ab.Ae_Line_Id = Cux_Temp.Reference9
      ;
      p_return_text := p_return_text || v_return;
    END LOOP;
  EXCEPTION
    WHEN no_data_found THEN
      p_return_text := NULL;
    WHEN OTHERS THEN
      p_return_text := p_return_text || 'д�ռ��ʴ�����Ϣʧ�ܣ�' ||
                       substr(SQLERRM, 1, 200);
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.WRITE_INTERFACE_REPORT_P',
                             p_error_message => 'д�ռ��ʴ�����Ϣʧ�ܣ�' ||
                                                substr(SQLERRM, 1, 200));
  END write_interface_report_p;

  -------------------------------------------------
  --added by eddie 2011-04-14

  -------------------------------------------------

  -------------------------------------------------
  --����������������
  PROCEDURE p_submit_req_p(errbuf        OUT VARCHAR2,
                           retcode       OUT NUMBER,
                           p_req_id      IN NUMBER,
                           p_source      IN VARCHAR2,
                           p_org_id      IN NUMBER,
                           p_period_name IN VARCHAR2) IS
    l_error_msg        VARCHAR2(2000);
    v_req_id           NUMBER;
    v_return           VARCHAR2(32767);
    v_return_text      VARCHAR2(32767);
    v_return_text1     VARCHAR2(32767);
    v_return_text2     VARCHAR2(32767);
    l_req_id           NUMBER;
    v_count1           NUMBER;
    v_count2           NUMBER;
    v_req_id1          NUMBER;
    v_req_id2          NUMBER;
    v_je_source_name   VARCHAR2(100);
    v_je_category_name VARCHAR2(100);
    v_count            NUMBER;
    v_header_id        NUMBER;
    v_header_id1       NUMBER;
    v_count_sum        NUMBER;
    v_data_inval EXCEPTION;
    v_batch_name   VARCHAR2(240);
    v_gl_date      VARCHAR2(20);
    v_batch_id     NUMBER;
    v_group_id     NUMBER;
    v_je_batch     t_je_batch;
    v_org_id       VARCHAR2(20) := fnd_profile.value('ORG_ID');
    v_same_org     VARCHAR2(240) := fnd_profile.value('CUX_SECU_SAME_COMPANY_CODE');
    v_count_temp   NUMBER;
    v_requst_id    NUMBER;
    v_source       VARCHAR2(20);
    l_phase        VARCHAR2(80);
    l_status       VARCHAR2(80);
    l_dev_phase    VARCHAR2(80);
    l_dev_status   VARCHAR2(80);
    l_message      VARCHAR2(80);
    l_wait_outcome BOOLEAN;
    CURSOR cux_update_att(l_je_category_name VARCHAR2,
                          l_je_source_name   VARCHAR2,
                          l_period_name      VARCHAR2,
                          l_req_id           NUMBER) IS
      SELECT gjl.*
        FROM gl_je_headers gjh, gl_je_lines gjl
       WHERE gjl.je_header_id = gjh.je_header_id
         AND gjh.je_category = l_je_category_name
         AND gjh.je_source = l_je_source_name
         AND gjh.period_name = l_period_name
         AND gjl.reference_10 = l_req_id
       ORDER BY gjl.reference_8;
  
  BEGIN
    log('****************START****************');
    log(p_org_id); -- Get_Gl_Period(v_Accounting_Date, v_Period_Name, v_Return);
    v_return_text := v_return_text || v_return;
    v_req_id      := fnd_global.conc_request_id;
    SELECT COUNT(1)
      INTO v_count2
      FROM cux.cux_gl_import_lines_all cgl
     WHERE cgl.period_name = p_period_name
       AND cgl.org_id = p_org_id;
    IF v_count2 > 0 THEN
      v_source := 'M';
    END IF;
    --step_000 ��������
    IF v_source = 'M' THEN
      --��ȡreq_id
      SELECT cgl.req_id
        INTO v_req_id2
        FROM cux.cux_gl_import_lines_all cgl
       WHERE cgl.period_name = p_period_name
         AND cgl.org_id = p_org_id
         AND rownum = 1;
      -- ����Ƿ����Ѿ�����ERPϵͳ������
      SELECT COUNT(1)
        INTO v_count_temp
        FROM gl_je_headers gjh, gl_je_lines gjl, gl_code_combinations gcc --,cux.Cux_Ps_Import_Je_Lines_Sum t
       WHERE
      -- t.je_header_id = gjh.je_header_id
      -- t.Je_Lines_Id=gjl.JE_LINE_NUM
       gjh.reversed_je_header_id IS NULL
       AND (gjh.accrual_rev_status = 'N' OR gjh.accrual_rev_status IS NULL)
       AND gjh.period_name = p_period_name
       AND gjh.je_source = '42'
       AND gjh.je_header_id = gjl.je_header_id
       AND gjl.period_name = p_period_name
       AND gjl.code_combination_id = gcc.code_combination_id
       AND gcc.segment1 = get_org_code1(p_org_id);
      log(v_count_temp);
      IF v_count_temp > 0 THEN
        v_return_text := v_return_text || '�ڼ�Ϊ��' || p_period_name ||
                         ' �������Ѿ��ɹ�����ORACLEϵͳ�������ظ�����';
        log(v_return_text);
        app_exception.raise_exception;
      END IF;
      UPDATE cux.cux_gl_import_lines_all t
         SET t.request_id        = v_req_id,
             t.source_code       = 'M',
             t.org_id            = decode(t.ccid_segment1,
                                          cux_gl_expense_import_pkg.get_org_code1(p_org_id),
                                          p_org_id),
             t.period_name       = p_period_name,
             t.status            = 'A',
             t.creation_date     = SYSDATE,
             t.created_by        = fnd_global.user_id,
             t.last_update_date  = SYSDATE,
             t.last_updated_by   = fnd_global.user_id,
             t.last_update_login = fnd_global.login_id
       WHERE (t.req_id = v_req_id2)
         AND t.period_name = p_period_name;
      SELECT COUNT(*)
        INTO v_count1
        FROM cux.cux_ps_import_je_lines_sum t
       WHERE t.req_id = v_req_id2;
      IF v_count1 > 0 THEN
        DELETE FROM cux.cux_ps_import_je_lines_sum t
         WHERE t.req_id = v_req_id2;
        COMMIT;
      END IF;
    END IF;
    IF v_count2 = 0 THEN
      BEGIN
        SELECT COUNT(1)
          INTO v_count_temp
          FROM gl_je_headers gjh, gl_je_lines gjl, gl_code_combinations gcc --,cux.Cux_Ps_Import_Je_Lines_Sum t
         WHERE
        --  t.je_header_id = gjh.je_header_id
        --  and t.Je_Lines_Id=gjl.JE_LINE_NUM
         gjh.reversed_je_header_id IS NULL
         AND (gjh.accrual_rev_status = 'N' OR gjh.accrual_rev_status IS NULL)
         AND gjh.period_name = p_period_name
         AND gjh.je_source = '42'
         AND gjh.je_header_id = gjl.je_header_id
         AND gjl.period_name = p_period_name
         AND gjl.code_combination_id = gcc.code_combination_id
         AND gcc.segment1 = get_org_code1(p_org_id);
        log(v_count_temp);
        IF v_count_temp > 0 THEN
          v_return_text := v_return_text || '�ڼ�Ϊ��' || p_period_name ||
                           ' �������Ѿ��ɹ�����ORACLEϵͳ�������ظ�����';
          log(v_return_text);
          app_exception.raise_exception;
        END IF;
        SELECT cux_batches_s.nextval INTO v_req_id1 FROM dual;
        v_requst_id := fnd_request.submit_request('CUX',
                                                  'CUX:PSн�����ݵ���',
                                                  '',
                                                  '',
                                                  FALSE,
                                                  nvl(p_period_name,
                                                      to_char(SYSDATE,
                                                              'YYYY-MM')),
                                                  p_org_id,
                                                  v_req_id1);
      END;
    END IF;
    IF v_requst_id > 0 THEN
      COMMIT;
      l_wait_outcome := fnd_concurrent.wait_for_request(request_id => v_requst_id,
                                                        INTERVAL   => 10,
                                                        phase      => l_phase,
                                                        status     => l_status,
                                                        dev_phase  => l_dev_phase,
                                                        dev_status => l_dev_status,
                                                        message    => l_message);
      IF upper(l_dev_phase) = 'COMPLETE' AND upper(l_dev_status) = 'NORMAL' THEN
        BEGIN
          v_return_text := NULL;
        END;
      ELSE
        v_return_text := v_return_text + '�ύ�ӿڵ�����������ʧ��';
      END IF;
    END IF;
    --���㹲��������
    SELECT COUNT(*)
      INTO v_count_sum
      FROM cux.cux_gl_import_lines_all ta
     WHERE ta.req_id = nvl(v_req_id2, v_req_id1);
    log('��ѡ��' || v_count_sum || '������');
    IF v_count_sum = 0 THEN
      app_exception.raise_exception;
    END IF;
    get_je_source(p_user_je_source_name, v_je_source_name, v_return);
    v_return_text := v_return_text || v_return;
    --  get_je_category(p_user_je_category_name, v_je_category_name, v_return);
    -- v_return_text := v_return_text || v_return;
    --step_020 ��������֮ǰ�����������Ƿ��ڽӿڱ��С��Ƿ��Ѿ����͵�����
    --add by eddie 20110429
    pre_import1(p_req_id     => nvl(v_req_id2, v_req_id1),
                x_return_msg => v_return);
    log('������ܱ�');
    INSERT INTO cux.cux_ps_import_je_lines_sum
      SELECT cux_ps_je_import_header_s.nextval header_id,
             t.*,
             NULL,
             NULL,
             (fnd_global.user_id),
             SYSDATE,
             (fnd_global.user_id),
             SYSDATE,
             (fnd_global.login_id),
             NULL,
             NULL,
             NULL,
             NULL
        FROM cux_ps_import_je_lines_v t
       WHERE t.req_id = nvl(v_req_id2, v_req_id1);
    COMMIT;
    log('���ݲ���ӿڱ�');
    v_return_text := v_return_text || v_return;
    --step_030
    --���ݲ���ӿڱ�
    p_gl_import_p(p_req_id      => nvl(v_req_id2, v_req_id1),
                  p_org_id      => p_org_id,
                  p_period_name => p_period_name,
                  p_group_id    => v_group_id,
                  p_return_text => v_return);
    v_return_text := v_return_text || v_return;
    log('���ݲ���ӿڱ�' || nvl(v_return_text, '�����'));
    cux_util_pkg.conc_req_output('���ݲ���ӿڱ� ' || nvl(v_return_text, '�����'));
    COMMIT;
    --step_040 �ύ�ռ�������
    log('�ύ�ռ�������');
    p_run_gl_interface(nvl(v_req_id2, v_req_id1),
                       v_group_id,
                       v_je_source_name,
                       v_return);
    v_return_text := v_return_text || v_return;
    IF v_return IS NULL THEN
      UPDATE cux.cux_gl_import_lines_all t
         SET t.status = 'C'
       WHERE t.req_id = nvl(v_req_id2, v_req_id1);
      COMMIT;
    END IF;
    log('�ύ�ռ�������' || nvl(v_return, '�����'));
    /*   IF v_return IS NOT NULL THEN
      --edit by eddie 20100723
      update_status_p(v_req_id1, '', '', NULL, NULL, 'E', v_return);
      --ELSE
    END IF;*/
    /*   get_je_batch(v_req_id1,
    p_period_name,
    --v_Batch_Name,
    --v_Gl_Date,
    --v_Batch_Id,
    v_je_batch,
    v_return);*/
    --�����ռ���������ֵĴ���
    cux_gl_expense_import_pkg.post_import(p_je_category => v_je_category_name,
                                          p_period_name => p_period_name,
                                          p_req_id      => nvl(v_req_id2,
                                                               v_req_id1),
                                          p_return1     => v_return_text1,
                                          p_return2     => v_return_text2
                                          --   p_je_batch_id => v_je_batch(i) .je_batch_id
                                          );
    v_return_text := v_return_text || v_return_text1 || v_return_text2;
    log('�����ռ���������Ϣ');
    write_interface_report_p(v_group_id, v_return);
    COMMIT;
    v_return_text := v_return_text || v_return;
    log('�����ռ���������Ϣ' || nvl(v_return, '�����'));
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --����δ����ʱ��ȡ��������Ҫ����״̬
      cux_util_pkg.conc_req_output(substr(SQLERRM, 1, 200));
      log(substr(SQLERRM, 1, 200));
      cux_util_pkg.conc_req_output('****************END****************');
      log('****************END****************');
      v_return_text := v_return_text || substr(SQLERRM, 1, 200);
      cux_util_pkg.error_log(p_function_name => 'CUX_PAY_PKG.P_SUBMIT_REQ_P',
                             p_error_message => v_return_text);
  END;

  ------------------------------------------------------
  --���뱨�����

  -------------------------------------------------------
  --���뱨��

  -----------------------------------------------------

  --------------------------------------------------------
  --��ȡ����ļ�·��
  FUNCTION get_output_file(p_request_id IN NUMBER) RETURN VARCHAR2 AS
    l_file     VARCHAR2(1000);
    l_tmp_file VARCHAR2(255);
    l_tmp_num  NUMBER;
    l_path     VARCHAR2(255);
  BEGIN
    SELECT fcr.outfile_name
      INTO l_file
      FROM fnd_concurrent_requests fcr
     WHERE fcr.request_id = p_request_id;
    l_tmp_file := l_file;
    LOOP
      l_tmp_num := instr(l_tmp_file, '/');
      IF l_tmp_num > 0 THEN
        l_tmp_file := substr(l_tmp_file, l_tmp_num + 1);
      ELSE
        EXIT;
      END IF;
    END LOOP;
    l_tmp_num := length(l_tmp_file);
    l_path    := substr(l_file, 1, length(l_file) - l_tmp_num);
    l_path    := l_path || 'CUX_GL_IMPORT_RPT_' || p_request_id ||
                 '_1.EXCEL';
    RETURN l_path;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  --------------------------------------
  FUNCTION get_account_code(p_ccid IN NUMBER) RETURN VARCHAR2 IS
    v_account_code VARCHAR2(240);
  BEGIN
    SELECT gcc.segment3
      INTO v_account_code
      FROM gl_code_combinations gcc
     WHERE gcc.code_combination_id = p_ccid;
    RETURN v_account_code;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  ------------------------------------------
  /* FUNCTION Get_Pay_Create_By(p_Apply_Id    IN NUMBER,
                             p_Type        IN VARCHAR2,
                             p_Return_Type IN VARCHAR2 DEFAULT 'NAME',
                             p_category    in varchar2 default null)
    RETURN VARCHAR2 IS
    v_Create_By    VARCHAR2(2000);
    v_Quik_Flag    VARCHAR2(20);
    v_Source_Table VARCHAR2(200);
    v_Source_Id    NUMBER;
  BEGIN
    BEGIN
      SELECT a.Source_Id,
             a.Source_Table
        INTO v_Source_Id,
             v_Source_Table
        FROM Cux.CUX_Pay_Apply_l_All a
       WHERE a.Apply_Id = p_Apply_Id
         AND Rownum = 1;
  
      IF v_Source_Table = 'CUX_EXPENSE_HEADERS_ALL'
      THEN
        SELECT a.Quick_Pay_Flag
          INTO v_Quik_Flag
          FROM Cux.CUX_Expense_Headers_All a
         WHERE a.Report_Header_Id = v_Source_Id;
      ELSIF v_Source_Table = 'CUX_INVOICES_ALL'
      THEN
        SELECT a.Quick_Pay_Flag
          INTO v_Quik_Flag
          FROM Cux.CUX_Invoices_All a
         WHERE a.Invoice_Id = v_Source_Id;
      ELSE
        v_Quik_Flag := 'N';
      END IF;
  
    EXCEPTION
      WHEN OTHERS THEN
        v_Quik_Flag := 'N';
    END;
  
    IF Nvl(p_Return_Type, 'NAME') = 'NAME'
    THEN
      IF Nvl(v_Quik_Flag, 'N') = 'Y'
      THEN
        --����߼������֧������Ϊ����֧���ģ�׷�ݵ���Դ���ݵ���֤��
        v_Create_By := CUX_Document_Approve_Pkg.Get_Approve_User_Name(NULL,
                                                                          NULL,
                                                                          p_Type,
                                                                          v_Source_Table,
                                                                          v_Source_Id,
                                                                          p_category);
      ELSE
        v_Create_By := CUX_Document_Approve_Pkg.Get_Approve_User_Name(NULL,
                                                                          NULL,
                                                                          p_Type,
                                                                          'CUX_PAY_APPLY_H_ALL',
                                                                          p_Apply_Id,
                                                                          p_category);
      END IF;
  
    ELSE
      IF Nvl(v_Quik_Flag, 'N') = 'Y'
      THEN
        --����߼������֧������Ϊ����֧���ģ�׷�ݵ���Դ���ݵ���֤��
        v_Create_By := CUX_Document_Approve_Pkg.Get_Approve_User_Id(NULL,
                                                                        NULL,
                                                                        p_Type,
                                                                        v_Source_Table,
                                                                        v_Source_Id);
      ELSE
        v_Create_By := CUX_Document_Approve_Pkg.Get_Approve_User_Id(NULL,
                                                                        NULL,
                                                                        p_Type,
                                                                        'CUX_PAY_APPLY_H_ALL',
                                                                        p_Apply_Id,
                                                                        p_category);
      END IF;
    END IF;
  
    RETURN v_Create_By;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  
  END Get_Pay_Create_By;*/
  ------------------------------------
  PROCEDURE post_import(p_je_category IN VARCHAR2,
                        p_period_name IN VARCHAR2,
                        p_req_id      IN NUMBER,
                        p_return1     OUT VARCHAR2,
                        p_return2     OUT VARCHAR2,
                        p_je_batch_id IN NUMBER DEFAULT NULL) IS
    CURSOR cux_update_att(l_period_name VARCHAR2, l_req_id NUMBER) IS
      SELECT gjl.*
        FROM gl_je_headers gjh, gl_je_lines gjl, gl_je_batches gjb
       WHERE -- gjb.je_batch_id = nvl(p_je_batch_id, gjb.je_batch_id) AND
       gjb.je_batch_id = gjh.je_batch_id
       AND gjl.je_header_id = gjh.je_header_id
      --  AND gjh.je_category = l_je_category_name
      --  AND gjh.je_source = l_je_source_name
       AND gjh.period_name = p_period_name
       AND gjl.reference_3 = to_char(l_req_id);
    --  ORDER BY gjl.reference_4;
    v_return_text1 VARCHAR2(2000);
    v_return_text2 VARCHAR2(2000);
    v_return       VARCHAR2(2000);
    v_header_id    NUMBER;
    v_header_id1   NUMBER;
    v_ae_header_id NUMBER;
  BEGIN
    log('����post_import ����');
    FOR update_attribute IN cux_update_att(p_period_name, p_req_id) LOOP
      /*  log('���µ������ֶ�' || 'AE_HEADER_ID��' || update_attribute.reference_3 ||
      'REQ_ID��' || update_attribute.reference_4);*/
      UPDATE cux.cux_ps_import_je_lines_sum t
         SET t.je_header_id = update_attribute.je_header_id,
             t.je_lines_id  = update_attribute.je_line_num
       WHERE to_char(t.header_id) = (update_attribute.reference_4);
      update_attribute_p(p_je_header_id => update_attribute.je_header_id,
                         p_je_line_num  => update_attribute.je_line_num,
                         p_ae_line_id   => update_attribute.reference_4,
                         p_return       => v_return);
      -- v_header_id    := update_attribute.je_header_id;
    --    v_return_text1 := v_return_text1 || v_return;
    END LOOP;
    --   commit;
  END;

  --����ӿڱ�����ǰ������֤
  -----------------------------
  PROCEDURE pre_import1(p_req_id     IN NUMBER,
                        x_return_msg OUT NOCOPY VARCHAR2) IS
    CURSOR cux_gl_temp(p_req_id NUMBER) IS
      SELECT a.rowid row_id, a.*
        FROM cux.cux_gl_import_lines_all a
       WHERE a.req_id = p_req_id;
    v_je_category VARCHAR2(240);
    v_je_source   VARCHAR2(240);
    v_period      VARCHAR2(240);
    v_count       NUMBER;
    v_tmp_count   NUMBER;
    v_return      VARCHAR2(32767);
    v_error       VARCHAR2(32767);
    v_ccid        NUMBER;
    l_flag        VARCHAR2(1);
    l_msg         VARCHAR2(2000);
    l_ccid        NUMBER;
  BEGIN
    log('����������֤����');
    FOR rec_validate_data IN cux_gl_temp(p_req_id) LOOP
      BEGIN
        l_flag := 'T';
        l_msg  := NULL;
        SAVEPOINT sp_validate_inv;
        --    log('��֤��˾');
        IF rec_validate_data.ccid_segment1 IS NULL THEN
          l_flag := 'F';
          l_msg  := substrb(l_msg || ' ��'||rec_validate_data.Line_Id||'��ӳ���˾������', 1, 2000);
          log(l_msg);
        END IF;
        --    log('��֤ƾ֤���');
        IF rec_validate_data.user_je_category_name = '�Ҳ������' THEN
          l_flag := 'F';
          l_msg  := substrb(l_msg || ' ��'||rec_validate_data.Line_Id||'��ӳ����Ҳ���ƾ֤���', 1, 2000);
           log(l_msg);
        END IF;
        --     log('��֤�ɱ�����');
        IF rec_validate_data.ccid_segment2 = ' ��'||rec_validate_data.Line_Id||'���Ҳ����ɱ�����' THEN
          l_flag := 'F';
          l_msg  := substrb(l_msg || ' ��'||rec_validate_data.Line_Id||'��ӳ����Ҳ����ɱ�����', 1, 2000);
           log(l_msg);
        END IF;
        --      log('��֤��Ŀ');
        IF rec_validate_data.ccid_segment3 IS NULL THEN
          l_flag := 'F';
          l_msg  := substrb(l_msg || ' ��'||rec_validate_data.Line_Id||'��ӳ����Ҳ�����Ŀ', 1, 2000);
           log(l_msg);
        END IF;
        --    l_flag := 'F';
        l_ccid := create_ccid(nvl(rec_validate_data.ccid_segment1, 0) || '.' ||
                              nvl(rec_validate_data.ccid_segment2, 0) || '.' ||
                              nvl(rec_validate_data.ccid_segment3, 0) || '.' ||
                              nvl(rec_validate_data.ccid_segment4, 0) ||
                              '.0.0.0.0.0.0');
        --     l_msg  := substrb(l_msg || ' ORACLE���Ҳ�����Ӧ��Ŀ,���Զ�����ccid '||to_char(nvl(l_ccid,0)), 1, 2000);
        --    log('Result:' || l_flag || ' ' || l_msg);
          IF l_ccid='0' THEN
          l_flag := 'F';
          l_msg  := substrb(l_msg || ' ��'||rec_validate_data.Line_Id||'�д���CCIDʧ�ܣ�����EBSϵͳ�ɱ�����', 1, 2000);
           log(l_msg);
        END IF;
        IF l_flag = 'T' THEN
          UPDATE cux.cux_gl_import_lines_all t
             SET t.status = 'V'
           WHERE t.rowid = rec_validate_data.row_id;
        ELSE
          UPDATE cux.cux_gl_import_lines_all t
             SET t.msg = l_msg
           WHERE t.rowid = rec_validate_data.row_id;
        END IF;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK TO sp_validate_inv;
          log('Unexpected Exception:' || SQLERRM);
      END;
    END LOOP;
    /*   SELECT COUNT(1)
      INTO v_tmp_count
      FROM cux.cux_gl_import_lines_all a
     WHERE a.req_id = p_req_id
       AND a.msg IS NOT NULL;
    IF v_tmp_count > 0 THEN
      log('��������Ϊ' || to_char(p_req_id) || '�������в����ϵ����ݲ��ܵ���');
      app_exception.raise_exception;
    END IF; -- by eddie ��ʱע���*/
  EXCEPTION
    WHEN OTHERS THEN
      x_return_msg := 'Unexpected Exception:' || SQLERRM;
      log(x_return_msg);
  END;

  FUNCTION create_ccid(p_concatenated_segments IN VARCHAR2) RETURN VARCHAR2 IS
    l_ccid                NUMBER;
    l_msg                 VARCHAR2(1000);
    l_chart_of_account_id NUMBER;
    l_set_of_book_id      NUMBER;
  BEGIN
    l_set_of_book_id := fnd_profile.value('GL_SET_OF_BKS_ID');
    SELECT gsob.chart_of_accounts_id
      INTO l_chart_of_account_id
      FROM gl_sets_of_books gsob
     WHERE gsob.set_of_books_id = l_set_of_book_id;
    l_ccid := fnd_flex_ext.get_ccid(application_short_name => 'SQLGL',
                                    key_flex_code          => 'GL#',
                                    structure_number       => l_chart_of_account_id,
                                    validation_date        => to_char(SYSDATE,
                                                                      'DD-MON-YYYY'),
                                    concatenated_segments  => p_concatenated_segments);
    IF l_ccid = 0 THEN
    --fnd_message.get;
      RETURN '0';
    ELSE
      RETURN to_char(l_ccid);
    END IF;
  END;

  -----------------------------

  -----------------------
  FUNCTION get_je_header_id(p_ae_header_id IN NUMBER) RETURN VARCHAR2 IS
    v_je_category  VARCHAR2(240);
    v_je_source    VARCHAR2(240);
    v_period       VARCHAR2(240);
    v_count        NUMBER;
    v_return       VARCHAR2(24000);
    v_ae_header_id NUMBER;
    v_je_header_id NUMBER;
  BEGIN
    get_je_category(p_user_je_category_name1, v_je_category, v_return);
    get_je_source(p_user_je_source_name, v_je_source, v_return);
    SELECT a.ae_header_id, a.period_name
      INTO v_ae_header_id, v_period
      FROM cux.cux_ae_headers_all a
     WHERE a.ae_header_id = p_ae_header_id;
    SELECT b.je_header_id
      INTO v_je_header_id
      FROM gl_je_lines a, gl_je_headers b
     WHERE a.je_header_id = b.je_header_id
       AND a.reference_8 = to_char(v_ae_header_id)
       AND b.je_source = v_je_source
       AND b.je_category = v_je_category
       AND b.period_name = v_period
       AND rownum = 1;
    RETURN v_je_header_id;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  -----------------------------
  PROCEDURE re_wirte_status(p_ae_header_id IN NUMBER) IS
    v_je_category  VARCHAR2(240);
    v_je_source    VARCHAR2(240);
    v_period       VARCHAR2(240);
    v_count        NUMBER;
    v_ae_header_id NUMBER;
    v_return       VARCHAR2(32767);
    v_error        VARCHAR2(32767);
    CURSOR cux_update_att(l_je_category_name VARCHAR2,
                          l_je_source_name   VARCHAR2,
                          l_period_name      VARCHAR2,
                          l_ae_header_id     NUMBER) IS
      SELECT gjl.*
        FROM gl_je_headers gjh, gl_je_lines gjl, gl_je_batches gjb
       WHERE gjb.je_batch_id = gjh.je_batch_id
         AND gjl.je_header_id = gjh.je_header_id
         AND gjh.je_category = l_je_category_name
         AND gjh.je_source = l_je_source_name
         AND gjh.period_name = l_period_name
         AND gjl.reference_8 = l_ae_header_id
       ORDER BY gjl.reference_8;
    v_header_id1   NUMBER;
    v_return_text1 VARCHAR2(32767);
    v_return_text2 VARCHAR2(32767);
  BEGIN
    get_je_category(p_user_je_category_name1, v_je_category, v_return);
    get_je_source(p_user_je_source_name, v_je_source, v_return);
    /* FOR Cux_Cur IN Cux_Gl_Temp(p_Req_Id)
    LOOP
      BEGIN*/
    SELECT a.ae_header_id, a.period_name
      INTO v_ae_header_id, v_period
      FROM cux.cux_ae_headers_all a
     WHERE a.ae_header_id = p_ae_header_id;
    SELECT COUNT(1)
      INTO v_count
      FROM gl_interface a
     WHERE a.reference28 = to_char(v_ae_header_id)
       AND a.user_je_category_name = p_user_je_category_name1
       AND a.user_je_source_name = p_user_je_source_name
       AND a.period_name = v_period;
    IF v_count > 0 THEN
      DELETE FROM gl_interface a
       WHERE a.reference28 = to_char(v_ae_header_id)
         AND a.user_je_category_name = p_user_je_category_name1
         AND a.user_je_source_name = p_user_je_source_name
         AND a.period_name = v_period;
    END IF;
    SELECT COUNT(1)
      INTO v_count
      FROM gl_je_lines a, gl_je_headers b
     WHERE a.je_header_id = b.je_header_id
       AND a.reference_8 = to_char(v_ae_header_id)
       AND b.je_source = v_je_source
       AND b.je_category = v_je_category
       AND b.period_name = v_period;
    IF v_count > 0 THEN
      --�Ѵ������ռ�����
      --��д״̬
      FOR update_attribute IN cux_update_att(v_je_category,
                                             v_je_source,
                                             v_period,
                                             v_ae_header_id) LOOP
        update_attribute_p(p_je_header_id => update_attribute.je_header_id,
                           p_je_line_num  => update_attribute.je_line_num,
                           p_ae_line_id   => update_attribute.reference_9,
                           p_return       => v_return);
        -- v_Header_Id    := Update_Attribute.Je_Header_Id;
        v_return_text1 := v_return_text1 || v_return;
        IF v_return IS NOT NULL THEN
          update_status_p(update_attribute.reference_10,
                          update_attribute.reference_8,
                          update_attribute.reference_9,
                          update_attribute.je_header_id,
                          update_attribute.je_line_num,
                          'E',
                          v_return);
        END IF;
        --���¸�������
        IF nvl(v_header_id1, -1) != update_attribute.reference_8 THEN
          v_header_id1 := update_attribute.reference_8;
          --�����Ƶ��ˣ������
          /*p_Update_Create_By(Update_Attribute.Reference_8,
          Update_Attribute.Je_Header_Id,
          v_Return_Text2);*/
          IF v_return_text2 IS NOT NULL THEN
            -- v_ae_header_id := to_number(Update_Attribute.reference_8);
            update_status_p(update_attribute.reference_10,
                            v_ae_header_id,
                            '',
                            '',
                            '',
                            'B',
                            '�����Ƶ��ˡ������ʧ��' || substr(SQLERRM, 1, 200));
          END IF;
          --���¸�������
        
        END IF;
      END LOOP;
      --------------------------------
    END IF;
  END;

  /*  END LOOP;*/
  --END;
  ------------------------------------------------------------

  ------------------------

  PROCEDURE p_gl_batch_post(p_batch_id    IN NUMBER,
                            x_return_text OUT VARCHAR2) IS
    v_req_id         NUMBER;
    l_phase          VARCHAR2(80);
    l_status         VARCHAR2(80);
    l_dev_phase      VARCHAR2(80);
    l_dev_status     VARCHAR2(80);
    l_message        VARCHAR2(80);
    l_wait_outcome   BOOLEAN;
    v_sub_request_id NUMBER;
    l_posting_run_id NUMBER;
    l_sob_id         NUMBER;
    l_coa_id         NUMBER;
  BEGIN
    SELECT sob.set_of_books_id, sob.chart_of_accounts_id
      INTO l_sob_id, l_coa_id
      FROM gl_sets_of_books sob
     WHERE sob.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID');
    l_posting_run_id := gl_je_batches_post_pkg.get_unique_id;
    -- p_Return_Text := p_Return_Text || '�ύ�ռ��ʹ�������ʧ��';
    v_req_id := fnd_request.submit_request('SQLGL', --Ӧ��ģ���������д
                                           'GLPPOS', --Ӧ�ó����������д
                                           '',
                                           '',
                                           FALSE, --Ĭ��Ϊ FALSE
                                           l_sob_id,
                                           l_coa_id,
                                           l_posting_run_id);
    IF v_req_id > 0 THEN
      UPDATE gl_je_batches gjb
         SET gjb.status         = 'S',
             gjb.posting_run_id = l_posting_run_id,
             gjb.request_id     = v_req_id
       WHERE gjb.je_batch_id = p_batch_id;
      COMMIT;
    ELSE
      x_return_text := '�ύ�ռ�������������ʧ��';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      x_return_text := x_return_text || '�ύ�ռ�������������ʧ��' || SQLERRM;
      cux_util_pkg.error_log(p_function_name => 'CUX_GL_Expense_Import.p_gl_batch_post',
                             p_error_message => '�ύ�ռ�������������ʧ��' || SQLERRM);
  END p_gl_batch_post;

  FUNCTION get_je_batch_by_ae(p_ae_header_id IN NUMBER, p_type IN VARCHAR2)
    RETURN VARCHAR2 IS
    l_je_batch_id       NUMBER;
    l_je_batch_name     gl_je_batches.name%TYPE;
    l_document_type_seq VARCHAR2(150);
  BEGIN
    SELECT gjb.je_batch_id,
           gjb.name,
           (SELECT ffv.attribute4
              FROM fnd_flex_values_vl ffv, fnd_flex_value_sets ffvs
             WHERE ffv.flex_value_set_id = ffvs.flex_value_set_id
               AND ffvs.flex_value_set_name = 'CUX_DOCUMENTS_TYPE'
               AND ffv.description =
                   substr(gjb.name,
                          instr(gjb.name, '-', 1, 1) + 1,
                          instr(gjb.name, '-', 1, 2) -
                          instr(gjb.name, '-', 1, 1) - 1)
               AND rownum < 2) document_type_seq
      INTO l_je_batch_id, l_je_batch_name, l_document_type_seq
      FROM gl_je_batches          gjb,
           gl_je_headers          gjh,
           cux.cux_ae_headers_all aeh,
           cux.cux_ae_lines_all   ael
     WHERE gjb.je_batch_id = gjh.je_batch_id
       AND aeh.ae_header_id = ael.ae_header_id
       AND aeh.ae_header_id = p_ae_header_id
       AND ael.return_source_table = 'GL_JE_LINES'
       AND gjh.je_header_id = ael.return_source_id
       AND rownum < 2;
    IF p_type = 'ID' THEN
      RETURN(to_char(l_je_batch_id));
    ELSIF p_type = 'NAME' THEN
      RETURN(l_je_batch_name);
    ELSIF p_type = 'DOCUMENT_TYPE_SEQ' THEN
      RETURN(l_document_type_seq);
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END get_je_batch_by_ae;

  PROCEDURE jv_post_wait(p_period_name IN VARCHAR2,
                         p_request_id  IN NUMBER,
                         p_je_batch_id IN NUMBER) IS
    CURSOR c_jv_post IS
      SELECT DISTINCT gjb.request_id
        FROM gl_je_headers        gjh,
             gl_je_batches        gjb,
             gl_je_lines          gjl,
             gl_code_combinations gcc
       WHERE gjb.je_batch_id = gjh.je_batch_id
         AND gjh.period_name = p_period_name
         AND gjh.je_source = '41'
         AND gjh.je_batch_id = nvl(p_je_batch_id, gjh.je_batch_id)
         AND gjh.je_header_id = gjl.je_header_id
         AND gjl.reference_10 = to_char(p_request_id)
         AND gjl.code_combination_id = gcc.code_combination_id
      --    and CUX_gw_util_pkg.check_if_function_enabled('PZBHPX', gcc.segment1) = 'Y'
      --ע��by eddie 2016-10-17 
      ;
    l_phase        VARCHAR2(80);
    l_status       VARCHAR2(80);
    l_dev_phase    VARCHAR2(80);
    l_dev_status   VARCHAR2(80);
    l_message      VARCHAR2(80);
    l_wait_outcome BOOLEAN;
  BEGIN
    FOR r_jv_post IN c_jv_post LOOP
      l_wait_outcome := fnd_concurrent.wait_for_request(request_id => r_jv_post.request_id,
                                                        INTERVAL   => 5,
                                                        max_wait   => 1800,
                                                        phase      => l_phase,
                                                        status     => l_status,
                                                        dev_phase  => l_dev_phase,
                                                        dev_status => l_dev_status,
                                                        message    => l_message);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      log(SQLERRM);
  END jv_post_wait;

END cux_gl_expense_import_pkg;
/
