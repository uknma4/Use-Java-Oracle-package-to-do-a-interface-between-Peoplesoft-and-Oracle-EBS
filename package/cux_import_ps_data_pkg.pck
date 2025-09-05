CREATE OR REPLACE PACKAGE cux_import_ps_data_pkg IS

  -- Author  : EDDIE
  -- Created : 2018/9/3 20:25:50
  -- Purpose : 
  -- Public type declarations
  FUNCTION get_interface_data(period_name   IN VARCHAR2,
                              req_id        IN VARCHAR2,
                              org_id        IN VARCHAR2,
                              p_applid      IN VARCHAR2,
                              company_code  IN VARCHAR2,
                              version       IN VARCHAR2,
                              user_id       IN VARCHAR2,
                              login_id      IN VARCHAR2,
                              request_id    IN VARCHAR2,
                              connectstring IN VARCHAR2,
                              appspw        IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE main(errbuf        OUT VARCHAR2,
                 retcode       OUT NUMBER,
                 p_period_name IN VARCHAR2,
                 p_org_id      IN NUMBER,
                 p_req_id      IN NUMBER);

END cux_import_ps_data_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_import_ps_data_pkg IS

  PROCEDURE log(p_msg IN VARCHAR2) IS
  BEGIN
    fnd_file.put_line(fnd_file.log, p_msg);
  END log;

  FUNCTION get_interface_data(period_name   IN VARCHAR2,
                              req_id        IN VARCHAR2,
                              org_id        IN VARCHAR2,
                              p_applid      IN VARCHAR2,
                              company_code  IN VARCHAR2,
                              version       IN VARCHAR2,
                              user_id       IN VARCHAR2,
                              login_id      IN VARCHAR2,
                              request_id    IN VARCHAR2,
                              connectstring IN VARCHAR2,
                              appspw        IN VARCHAR2) RETURN VARCHAR2 AS
    LANGUAGE JAVA NAME 'com/rh/core/input/GetDIDIdata.GetDIDIrequestDATA(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String) return java.lang.String';

  PROCEDURE main(errbuf        OUT VARCHAR2,
                 retcode       OUT NUMBER,
                 p_period_name IN VARCHAR2,
                 p_org_id      IN NUMBER,
                 p_req_id      IN NUMBER) IS
    jsonstr       VARCHAR2(32767);
    v_tag         VARCHAR2(50);
    v_return_text VARCHAR2(32767);
    v_req_id      NUMBER;
    v_return      VARCHAR(1000);
    v_count_temp  NUMBER;
  BEGIN
    SELECT flv.tag
      INTO v_tag
      FROM fnd_lookup_values flv
     WHERE flv.lookup_type = 'CUX_HR_ENT_MAPPING'
       AND flv.language = 'ZHS'
       AND flv.meaning =
           (SELECT hou.short_code
              FROM hr_operating_units hou
             WHERE hou.organization_id = fnd_profile.value('ORG_ID'));
    SELECT COUNT(*)
      INTO v_count_temp
      FROM cux.cux_gl_import_lines_all t
     WHERE t.ps_segment1 = v_tag
       AND t.period_name = (p_period_name);
    IF v_count_temp > 0 THEN
      SELECT req_id
        INTO v_req_id
        FROM cux.cux_gl_import_lines_all t
       WHERE t.ps_segment1 = v_tag
         AND t.period_name =
             nvl(p_period_name, to_char(SYSDATE, 'YYYY-MM'))
         AND rownum = 1;
      v_return_text := v_return_text || '期间为：' || p_period_name ||
                       ' 的数据本期间已经取过数据，不能重复导入';
      log(v_return_text);
     -- cux_util_pkg.conc_req_log(v_return_text);
      app_exception.raise_exception;
    ELSE
      log(p_period_name);
      jsonstr := cux_import_ps_data_pkg.get_interface_data(p_period_name,
                                                           nvl(p_req_id,1),
                                                           nvl(p_org_id,
                                                               fnd_profile.value('ORG_ID')),
                                                        '100502001',
                                                           v_tag,
                                                           'V3',
                                                           (fnd_global.user_id),
                                                           (fnd_global.login_id),
                                                           fnd_global.conc_request_id,
                                                           'thin:@172.20.24.52:1521:HTWDEV',
                                                           'apps');
    END IF;
    log('此次共插入'||jsonstr||'行数据');
  EXCEPTION
    WHEN OTHERS THEN
      v_return := substr(SQLERRM, 1, 200);
      cux_util_pkg.conc_req_log('获取接口数据失败,请检查lookupcode设置' || v_return);
  END main;

END cux_import_ps_data_pkg;
/
