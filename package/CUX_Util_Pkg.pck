CREATE OR REPLACE PACKAGE CUX_Util_Pkg IS
  g_Sob_Id NUMBER := Nvl(Fnd_Profile.VALUE('GL_SET_OF_BKS_ID'), 1001);

  --
  -- Package
  --   Cux_Cap_Util_Pkg
  -- Purpose
  --   CAP Public Util Pkg
  -- History
  --   2009.10.20   Nie.Zhiqiang    Created
  --

  --==============================================
  -- Procedure:
  --   Conc_Req_Log
  -- Purpose:
  --   Output Concurrent Request Log Message
  --==============================================
  PROCEDURE Conc_Req_Log(p_Msg IN VARCHAR2);

  --==============================================
  -- Procedure:
  --   Conc_Req_Output
  -- Purpose:
  --   Output Concurrent Request Output Message
  --==============================================
  PROCEDURE Conc_Req_Output(p_Msg IN VARCHAR2);

  PROCEDURE req_out(p_Msg IN VARCHAR2);
  PROCEDURE req_log(p_Msg IN VARCHAR2);

  --==============================================
  -- Procedure:
  --   Error_Log
  -- Purpose:
  --   Insert Error Messages into Log Table
  --==============================================
  PROCEDURE Error_Log(p_Function_Name      IN VARCHAR2,
                      p_Error_Message      IN VARCHAR2,
                      p_Attribute_Category IN VARCHAR2 DEFAULT NULL,
                      p_Attribute1         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute2         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute3         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute4         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute5         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute6         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute7         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute8         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute9         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute10        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute11        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute12        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute13        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute14        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute15        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute16        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute17        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute18        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute19        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute20        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute21        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute22        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute23        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute24        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute25        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute26        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute27        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute28        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute29        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute30        IN VARCHAR2 DEFAULT NULL);

Function Transform_Xml_Entity(p_Value In Varchar2) Return Varchar2;

  /*FUNCTION Check_Security(p_Source          IN VARCHAR2,
                          p_Org_Id          IN NUMBER,
                          p_Second_Org_Code IN VARCHAR2,
                          p_Parameter1      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter2      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter3      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter4      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter5      IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;*/

  FUNCTION Get_Second_Org_Code(p_Org_Id          IN NUMBER,
                               p_Second_Org_Code IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION Get_Next_Number(p_Source          IN VARCHAR2,
                           p_Document_Prefix IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION Get_Document_Number(p_Source      IN VARCHAR2,
                               p_Period_Name IN VARCHAR2 DEFAULT NULL,
                               p_Date        IN DATE DEFAULT SYSDATE,
                               p_Parameter1  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter2  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter3  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter4  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter5  IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

  /*FUNCTION Get_Main_Project(p_Project_Code IN VARCHAR2,
                            p_Project_Name IN VARCHAR2,
                            p_Type         IN VARCHAR2) RETURN VARCHAR2;*/

  /*FUNCTION Get_Main_Project_Id(p_Project_Id  IN NUMBER,
                               p_Type        IN VARCHAR2,
                               p_Return_Type IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;*/

  FUNCTION Get_Lookup_Meaning(p_Lookup_Type VARCHAR2,
                              p_Lookup_Code VARCHAR2) RETURN VARCHAR2;

  FUNCTION Get_Flex_Value_Meaning(p_Flex_Value_Set VARCHAR2,
                                  p_Flex_Value     VARCHAR2) RETURN VARCHAR2;

  PROCEDURE Get_Ccid_p(p_All_Segments IN VARCHAR2,
                       p_Ccid         OUT NUMBER,
                       p_Error_Msg    OUT VARCHAR2);

  FUNCTION Value_Set_Security(p_Security_Check_Mode IN VARCHAR2,
                              p_Flex_Value_Set_Id   IN NUMBER,
                              p_Parent_Flex_Value   IN VARCHAR2,
                              p_Flex_Value          IN VARCHAR2,
                              p_Resp_Application_Id IN NUMBER,
                              p_Responsibility_Id   IN NUMBER)
    RETURN VARCHAR2;

  FUNCTION Check_Segment_Security(p_Segment       IN VARCHAR2,
                                  p_Segment_Value IN VARCHAR2)
    RETURN VARCHAR2;

  function get_dff_column_name(p_flex_value_set_name in varchar2,
                               p_column_name in varchar2) return varchar2;

 function check_period_range (p_period in varchar2,
                           p_period_from in varchar2,
                           p_period_to in varchar2) return varchar2;

  FUNCTION Get_default_actual_Period(p_sob_id IN VARCHAR2 default null)
    RETURN VARCHAR2;

  FUNCTION Get_Ccid_Segments(p_Ccid IN NUMBER) RETURN VARCHAR2;

  FUNCTION Get_Ccid_Desc(p_Appl_Short_Name IN VARCHAR2 DEFAULT NULL,
                         p_Id_Flex_Code    IN VARCHAR2 DEFAULT NULL,
                         p_Id_Flex_Num     IN NUMBER DEFAULT NULL,
                         p_Ccid            IN NUMBER) RETURN VARCHAR2;

  FUNCTION Get_Comp_Code(p_Org_Id IN NUMBER) RETURN VARCHAR2;

  FUNCTION Get_parent_Comp_Code(p_company_code IN varchar2,
                                p_type in varchar2)
  RETURN VARCHAR2;

  FUNCTION Get_Org_Id(p_Comp_Code IN VARCHAR2) RETURN NUMBER;

  FUNCTION Get_User_Employee_Id(p_User_Id IN NUMBER) RETURN NUMBER;

  FUNCTION Get_User_Employee_name(p_User_Id IN NUMBER,
                                  p_type in varchar2) RETURN varchar2;

  FUNCTION Get_Period_Meaning(p_Period_Name IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION Get_Period_Info(p_Period_Name IN VARCHAR2,
                           p_Type        IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION Get_Period_by_date(p_date IN date,
                              p_type in varchar2) RETURN VARCHAR2;

END CUX_Util_Pkg;
/
CREATE OR REPLACE PACKAGE BODY CUX_Util_Pkg IS

  --==============================================
  -- Procedure:
  --   Conc_Req_Log
  -- Purpose:
  --   Output Concurrent Request Log Message
  --==============================================
  PROCEDURE Conc_Req_Log(p_Msg IN VARCHAR2) IS
  BEGIN
    IF Nvl(Fnd_Global.Conc_Request_Id, 0) > 0 THEN
      Fnd_File.Put_Line(Fnd_File.Log, p_Msg);
    ELSE
      NULL;
    END IF;
  END Conc_Req_Log;

  --==============================================
  -- Procedure:
  --   Conc_Req_Output
  -- Purpose:
  --   Output Concurrent Request Output Message
  --==============================================
  PROCEDURE Conc_Req_Output(p_Msg IN VARCHAR2) IS
  BEGIN
    IF Nvl(Fnd_Global.Conc_Request_Id, 0) > 0 THEN
      Fnd_File.Put_Line(Fnd_File.Output, p_Msg);
    ELSE
      NULL;
    END IF;
  END Conc_Req_Output;

  --==============================================
  -- Procedure:
  --   Conc_Req_Log
  -- Purpose:
  --   Output Concurrent Request Log Message
  --==============================================
  PROCEDURE req_out(p_Msg IN VARCHAR2) IS
  BEGIN
    IF Nvl(Fnd_Global.Conc_Request_Id, 0) > 0 THEN
      Fnd_File.Put_Line(Fnd_File.Log, p_Msg);
    ELSE
      NULL;
    END IF;
  END req_out;

  --==============================================
  -- Procedure:
  --   Conc_Req_Output
  -- Purpose:
  --   Output Concurrent Request Output Message
  --==============================================
  PROCEDURE req_log(p_Msg IN VARCHAR2) IS
  BEGIN
    IF Nvl(Fnd_Global.Conc_Request_Id, 0) > 0 THEN
      Fnd_File.Put_Line(Fnd_File.Output, p_Msg);
    ELSE
      NULL;
    END IF;
  END req_log;

  --==============================================
  -- Procedure:
  --   Error_Log
  -- Purpose:
  --   Insert Error Messages into Log Table
  --==============================================
  PROCEDURE Error_Log(p_Function_Name      IN VARCHAR2,
                      p_Error_Message      IN VARCHAR2,
                      p_Attribute_Category IN VARCHAR2 DEFAULT NULL,
                      p_Attribute1         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute2         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute3         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute4         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute5         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute6         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute7         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute8         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute9         IN VARCHAR2 DEFAULT NULL,
                      p_Attribute10        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute11        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute12        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute13        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute14        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute15        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute16        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute17        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute18        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute19        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute20        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute21        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute22        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute23        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute24        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute25        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute26        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute27        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute28        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute29        IN VARCHAR2 DEFAULT NULL,
                      p_Attribute30        IN VARCHAR2 DEFAULT NULL) IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    l_Log_Id NUMBER;
  BEGIN
    SELECT CUX_Error_Logs_s.NEXTVAL INTO l_Log_Id FROM Dual;

    INSERT INTO cux.CUX_Error_Logs
      (Log_Id,
       Function_Name,
       Error_Message,
       Attribute_Category,
       Attribute1,
       Attribute2,
       Attribute3,
       Attribute4,
       Attribute5,
       Attribute6,
       Attribute7,
       Attribute8,
       Attribute9,
       Attribute10,
       Attribute11,
       Attribute12,
       Attribute13,
       Attribute14,
       Attribute15,
       Attribute16,
       Attribute17,
       Attribute18,
       Attribute19,
       Attribute20,
       Attribute21,
       Attribute22,
       Attribute23,
       Attribute24,
       Attribute25,
       Attribute26,
       Attribute27,
       Attribute28,
       Attribute29,
       Attribute30,
       Creation_Date,
       Created_By,
       Last_Update_Date,
       Last_Updated_By,
       Last_Update_Login)
    VALUES
      (l_Log_Id,
       Substrb(Upper(p_Function_Name), 1, 100),
       Substrb(p_Error_Message, 1, 2000),
       p_Attribute_Category,
       p_Attribute1,
       p_Attribute2,
       p_Attribute3,
       p_Attribute4,
       p_Attribute5,
       p_Attribute6,
       p_Attribute7,
       p_Attribute8,
       p_Attribute9,
       p_Attribute10,
       p_Attribute11,
       p_Attribute12,
       p_Attribute13,
       p_Attribute14,
       p_Attribute15,
       p_Attribute16,
       p_Attribute17,
       p_Attribute18,
       p_Attribute19,
       p_Attribute20,
       p_Attribute21,
       p_Attribute22,
       p_Attribute23,
       p_Attribute24,
       p_Attribute25,
       p_Attribute26,
       p_Attribute27,
       p_Attribute28,
       p_Attribute29,
       p_Attribute30,
       SYSDATE,
       Fnd_Global.User_Id,
       SYSDATE,
       Fnd_Global.User_Id,
       Fnd_Global.Login_Id);
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END Error_Log;

Function Transform_Xml_Entity(p_Value In Varchar2) Return Varchar2 Is
    l_Value Varchar2(2000);
  Begin
    l_Value := p_Value;
    l_Value := Replace(l_Value, '<', ';');
    l_Value := Replace(l_Value, '>', ';');
    l_Value := Replace(l_Value, '&', ';');
    l_Value := Replace(l_Value, '''', ';');
    l_Value := Replace(l_Value, '"', ';');

    Return l_Value;
  End Transform_Xml_Entity;

  --==============================================
  -- Procedure:
  --
  -- Purpose:
  --   安全性屏蔽
  --==============================================
/*  FUNCTION Check_Security(p_Source          IN VARCHAR2,
                          p_Org_Id          IN NUMBER,
                          p_Second_Org_Code IN VARCHAR2,
                          p_Parameter1      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter2      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter3      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter4      IN VARCHAR2 DEFAULT NULL,
                          p_Parameter5      IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_Error_Msg        VARCHAR2(2000);
    l_Local_Function   VARCHAR2(80) := 'check_security';
    l_Org_Id           NUMBER;
    l_Second_Org_Code  VARCHAR2(30);
    l_Secu_Ou_Control  VARCHAR2(30);
    l_Secu_Ap          VARCHAR2(30);
    l_Org_Check        VARCHAR2(1);
    l_Second_Org_Check VARCHAR2(1);
    l_Ap_Check         VARCHAR2(1);
    l_super_org_id     varchar2(100);
    l_super_org_check  VARCHAR2(1);
    l_cap_role         varchar2(30);
    l_company_code_profile     varchar2(30);
    l_company_HQ_flag       varchar2(30);
    l_company_HQ       VARCHAR2(30);
    l_company_code     varchar2(30);
  BEGIN
    --IF p_source is null or p_source in ('Others','OTHERS') THEN
    begin
      l_super_org_id := fnd_profile.value('XLA_MO_TOP_REPORTING_LEVEL');
      if l_super_org_id = '2000' then --Legal Entity
         l_super_org_check := 'Y';
         l_cap_role := fnd_profile.value('CUX_ROLE');
         if l_cap_role is null then
            null;
         elsif l_cap_role = 'M' then
            l_Org_Id := Fnd_Profile.VALUE('ORG_ID');
            l_company_code_profile := CUX_util_pkg.Get_Comp_Code(l_Org_Id);
            l_company_HQ_flag := CUX_gw_util_pkg.check_company_HQ(l_company_code_profile);
            if l_company_HQ_flag = 'Y' then
               l_company_code := CUX_util_pkg.get_comp_code(p_Org_Id);
               l_company_HQ := CUX_gw_util_pkg.get_company_HQ(l_company_code);
               if nvl(l_company_HQ, 'Xyz123') = l_company_code_profile then
                  return('Y');
               else
                  return('N');
               end if;
            else
               if p_Org_Id = l_org_id then
                  return('Y');
               else
                  return('N');
               end if;
            end if;
         end if;

         return('Y');
      end if;
    exception
    when others then
      null;
    end;
    --added by lijun 2010-07-26

    IF p_Org_Id IS NULL THEN
      l_Org_Check := 'Y';
    ELSE
      l_Org_Id := Fnd_Profile.VALUE('ORG_ID');
      IF l_Org_Id IS NOT NULL THEN
        IF p_Org_Id = l_Org_Id THEN
          l_Org_Check := 'Y';
        ELSE
          l_Org_Check := 'N';
        END IF;
      ELSE
        l_Org_Check := 'Y';
      END IF;

      IF l_Org_Check = 'N' THEN
        RETURN('N');
      END IF;
    END IF;

    IF p_Second_Org_Code = 'ALL' THEN
      l_Second_Org_Check := 'Y';
    ELSE
      l_Second_Org_Code := Fnd_Profile.VALUE('CUX_SECU_SAME_COMPANY_CODE');

      IF l_Second_Org_Code IS NOT NULL THEN
        IF P_SOURCE IN ('PA_PROJECTS_ALL', 'PO_HEADERS_ALL') THEN
        --ADDED BY LIJUN 2010-08-04 项目和采购走物资安全性屏蔽
          l_Secu_Ou_Control := Fnd_Profile.VALUE('CUX_SECU_SAME_OU_CONTROL');
          IF (l_Secu_Ou_Control IS NULL)
             OR (l_Secu_Ou_Control <> 'UNIT') THEN
            l_Second_Org_Check := 'Y';
          ELSE
            IF p_Second_Org_Code = l_Second_Org_Code THEN
              l_Second_Org_Check := 'Y';
            ELSE
              l_Second_Org_Check := 'N';
            END IF;
          END IF;
        ELSE
           IF p_Second_Org_Code = l_Second_Org_Code THEN
              l_Second_Org_Check := 'Y';
           ELSE
              l_Second_Org_Check := 'N';
           END IF;
        END IF;
      ELSE
        l_Second_Org_Check := 'Y';
      END IF;
    END IF;

    IF p_Parameter1 = 'ALL' THEN
      l_Ap_Check := 'Y';
    ELSE
      l_Secu_Ap := Fnd_Profile.VALUE('NCGC:AP SECURITY');
      IF l_Secu_Ap IS NOT NULL THEN
        IF l_Secu_Ap = p_Parameter1 THEN
          l_Ap_Check := 'Y';
        ELSE
          l_Ap_Check := 'N';
        END IF;
      ELSE
        l_Ap_Check := 'Y';
      END IF;

    END IF;


    IF l_Org_Check = 'Y'
       AND l_Second_Org_Check = 'Y'
       AND l_Ap_Check = 'Y' THEN
      RETURN('Y');
    ELSE
      RETURN('N');
    END IF;
    --END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN('N');
  END Check_Security;

*/--2016-10-17 by eddie 方正电子不需要安全性
  --==============================================
  -- Procedure:
  --
  -- Purpose:
  --   取主项目ID
  --==============================================
  -- 注释2016-10-17 by eddie
/*  FUNCTION Get_Main_Project_Id(p_Project_Id  IN NUMBER,
                               p_Type        IN VARCHAR2,
                               p_Return_Type IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_Error_Msg         VARCHAR2(2000);
    l_Local_Function    VARCHAR2(80) := 'GET_MAIN_PROJECT_ID';
    l_Attribute6        VARCHAR2(150);
    l_Task_Id           NUMBER;
    l_Main_Project_Code VARCHAR2(240);
    l_Main_Project_Name VARCHAR2(240);
    l_Main_Project_Id   NUMBER;
  BEGIN
    --基层掌握资金
    BEGIN
      SELECT Ffv.Flex_Value_Id,
             Ffv.Flex_Value,
             Ffv.Description
        INTO l_Main_Project_Id,
             l_Main_Project_Code,
             l_Main_Project_Name
        FROM Cux_Pa_Pro_Kind_t   t,
             Pa_Projects_All     Ppa,
             Fnd_Flex_Values_Vl  Ffv,
             Fnd_Flex_Value_Sets Ffvs
       WHERE Ppa.Project_Id = p_Project_Id
         AND t.Project_Id = Ppa.Project_Id
         AND t.Capital_Ctrl_Code IS NOT NULL
         AND Ffvs.Flex_Value_Set_Name = 'CUX_GL_COA_PROJECT'
         AND Ffvs.Flex_Value_Set_Id = Ffv.Flex_Value_Set_Id
         AND Ffv.Flex_Value = t.Capital_Ctrl_Code
         AND Ffv.Attribute15 = 'CONTROL_FUND';
    EXCEPTION
      WHEN OTHERS THEN
        l_Main_Project_Id   := NULL;
        l_Main_Project_Code := NULL;
        l_Main_Project_Name := NULL;
    END;

    IF l_Main_Project_Id IS NOT NULL
       AND Nvl(p_Return_Type, 'FUND') = 'FUND' THEN
      IF p_Type = 'ID' THEN
        RETURN(l_Main_Project_Id);
      ELSIF p_Type = 'CODE' THEN
        RETURN(l_Main_Project_Code);
      ELSIF p_Type = 'NAME' THEN
        RETURN(l_Main_Project_Name);
      ELSE
        RETURN(l_Main_Project_Id);
      END IF;
    END IF;

    --added by lijun 2008-12-29
    BEGIN
      SELECT Attribute6
        INTO l_Attribute6
        FROM Pa_Projects_All Ppa
       WHERE Ppa.Project_Id = p_Project_Id
         AND Attribute6 IS NOT NULL;
    EXCEPTION
      WHEN OTHERS THEN
        l_Attribute6 := NULL;
    END;

    l_Task_Id := To_Number(l_Attribute6);

    SELECT (SELECT d.Detail_Id
              FROM Cux_Pa_Layout_Detail_t d
             WHERE d.Return_Task_Id = t.Task_Id
               AND d.Detail_Id =
                   (SELECT MAX(Detail_Id)
                      FROM Cux_Pa_Layout_Detail_t T1
                     WHERE T1.Return_Task_Id = t.Task_Id)) Main_Project_Id,
           Nvl((SELECT Detail_Code
                 FROM Cux_Pa_Layout_Detail_t d
                WHERE d.Return_Task_Id = t.Task_Id
                  AND d.Detail_Id =
                      (SELECT MAX(Detail_Id)
                         FROM Cux_Pa_Layout_Detail_t T1
                        WHERE T1.Return_Task_Id = t.Task_Id)),
               Ppa.Segment1 || '-' || t.Task_Number) Main_Project_Code,
           t.Long_Task_Name
      INTO l_Main_Project_Id,
           l_Main_Project_Code,
           l_Main_Project_Name
      FROM Pa_Tasks        t,
           Pa_Projects_All Ppa --虚拟归集项目
     WHERE Ppa.Project_Id = t.Project_Id
       AND t.Task_Id = l_Task_Id;

    IF l_Main_Project_Id IS NOT NULL
       AND Nvl(p_Return_Type, 'LAYOUT') = 'LAYOUT' THEN
      IF p_Type = 'ID' THEN
        RETURN(l_Main_Project_Id);
      ELSIF p_Type = 'CODE' THEN
        RETURN(l_Main_Project_Code);
      ELSIF p_Type = 'NAME' THEN
        RETURN(l_Main_Project_Name);
      ELSE
        RETURN(l_Main_Project_Id);
      END IF;
    END IF;

    RETURN(NULL);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Main_Project_Id;
*/
  --==============================================
  -- Procedure:
  --
  -- Purpose:
  --   取主项目
  --==============================================
  /*
  FUNCTION Get_Main_Project(p_Project_Code IN VARCHAR2,
                            p_Project_Name IN VARCHAR2,
                            p_Type         IN VARCHAR2) RETURN VARCHAR2 IS
    l_Error_Msg         VARCHAR2(2000);
    l_Local_Function    VARCHAR2(80) := 'GET_MAIN_PROJECT';
    l_Attribute6        VARCHAR2(150);
    l_Task_Id           NUMBER;
    l_Main_Project_Code VARCHAR2(240);
    l_Main_Project_Name VARCHAR2(240);
  BEGIN
    --基层掌握资金
    BEGIN
      SELECT Ffv.Flex_Value,
             Ffv.Description
        INTO l_Main_Project_Code,
             l_Main_Project_Name
        FROM Cux_Pa_Pro_Kind_t   t,
             Pa_Projects_All     Ppa,
             Fnd_Flex_Values_Vl  Ffv,
             Fnd_Flex_Value_Sets Ffvs
       WHERE Ppa.Segment1 = p_Project_Code
         AND t.Project_Id = Ppa.Project_Id
         AND t.Capital_Ctrl_Code IS NOT NULL
         AND Ffvs.Flex_Value_Set_Name = 'CUX_GL_COA_PROJECT'
         AND Ffvs.Flex_Value_Set_Id = Ffv.Flex_Value_Set_Id
         AND Ffv.Flex_Value = t.Capital_Ctrl_Code
         AND Ffv.Attribute15 = 'CONTROL_FUND';
    EXCEPTION
      WHEN OTHERS THEN
        l_Main_Project_Code := NULL;
        l_Main_Project_Name := NULL;
    END;

    IF l_Main_Project_Code IS NOT NULL THEN
      IF p_Type = 'CODE' THEN
        RETURN(l_Main_Project_Code);
      ELSIF p_Type = 'NAME' THEN
        RETURN(l_Main_Project_Name);
      ELSE
        RETURN(l_Main_Project_Code);
      END IF;
    END IF;

    --added by lijun 2008-12-29
    IF p_Project_Code IS NOT NULL
       AND p_Project_Code NOT IN ('0', 'T') THEN
      SELECT Attribute6
        INTO l_Attribute6
        FROM Pa_Projects_All Ppa
       WHERE Ppa.Segment1 = p_Project_Code
         AND Attribute6 IS NOT NULL;
      l_Task_Id := To_Number(l_Attribute6);

      SELECT Nvl((SELECT Detail_Code
                   FROM Cux_Pa_Layout_Detail_t d
                  WHERE d.Return_Task_Id = t.Task_Id
                    AND Rownum = 1),
                 Ppa.Segment1 || '-' || t.Task_Number) Main_Project_Code,
             t.Task_Name
        INTO l_Main_Project_Code,
             l_Main_Project_Name
        FROM Pa_Tasks        t,
             Pa_Projects_All Ppa --虚拟归集项目
       WHERE Ppa.Project_Id = t.Project_Id
         AND t.Task_Id = l_Task_Id;
    END IF;

    IF l_Main_Project_Code IS NOT NULL THEN
      IF p_Type = 'CODE' THEN
        RETURN(l_Main_Project_Code);
      ELSIF p_Type = 'NAME' THEN
        RETURN(l_Main_Project_Name);
      ELSE
        RETURN(l_Main_Project_Code);
      END IF;
    END IF;

    RETURN(NULL);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Main_Project;

*/
  FUNCTION Get_Lookup_Meaning(p_Lookup_Type VARCHAR2,
                              p_Lookup_Code VARCHAR2) RETURN VARCHAR2 IS
    l_Meaning VARCHAR2(80);
    CURSOR C1 IS
      SELECT Flv.Meaning
        FROM Fnd_Lookup_Values_Vl Flv
       WHERE Flv.Lookup_Type = p_Lookup_Type
         AND Flv.Lookup_Code = p_Lookup_Code;
  BEGIN
    l_Meaning := NULL;
    OPEN C1;
    FETCH C1
      INTO l_Meaning;
    CLOSE C1;
    RETURN l_Meaning;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Lookup_Meaning;

  FUNCTION Get_Flex_Value_Meaning(p_Flex_Value_Set VARCHAR2,
                                  p_Flex_Value     VARCHAR2) RETURN VARCHAR2 IS
    l_Meaning VARCHAR2(80);
    CURSOR C1 IS
      SELECT Ffv.Description
        FROM Fnd_Flex_Values_Vl  Ffv,
             Fnd_Flex_Value_Sets Ffvs
       WHERE Ffvs.Flex_Value_Set_Id = Ffv.Flex_Value_Set_Id
         AND Ffvs.Flex_Value_Set_Name = p_Flex_Value_Set
         AND Ffv.Flex_Value = p_Flex_Value;
  BEGIN
    l_Meaning := NULL;
    OPEN C1;
    FETCH C1
      INTO l_Meaning;
    CLOSE C1;
    RETURN l_Meaning;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Flex_Value_Meaning;

  FUNCTION Get_Period(p_Period_Name IN VARCHAR2) RETURN VARCHAR2 IS
    l_Local_Function VARCHAR2(200) := 'CUX_UTIL_PKG.get_period';
    l_Year_Month     VARCHAR2(30);
  BEGIN
    SELECT To_Char(p.Start_Date, 'YYMM')
      INTO l_Year_Month
      FROM Gl_Periods       p,
           Gl_Sets_Of_Books Sob
     WHERE Sob.Period_Set_Name = p.Period_Set_Name
       AND Sob.Set_Of_Books_Id = g_Sob_Id
       AND p.Period_Name = p_Period_Name;
    RETURN(l_Year_Month);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Period;

  FUNCTION Get_default_actual_Period(p_sob_id IN VARCHAR2 default null)
    RETURN VARCHAR2 IS
    l_Local_Function VARCHAR2(200) := 'CUX_UTIL_PKG.Get_default_actual_Period';

    default_period VARCHAR2(15);
    l_sob_id number;
    CURSOR get_latest_opened IS
    SELECT period_name
    FROM   gl_period_statuses
    WHERE  application_id = 101
    AND    set_of_books_id = l_sob_id

    AND    closing_status = 'O'
    AND    start_date = (SELECT max(start_date)
                         FROM gl_period_statuses
                         WHERE  application_id = 101
                         AND    set_of_books_id = l_sob_id
                         AND    closing_status = 'O')
    ORDER BY effective_period_num DESC;

  CURSOR get_earliest_future_ent IS
    SELECT period_name
    FROM   gl_period_statuses
    WHERE  application_id = 101
    AND    set_of_books_id = l_sob_id
    AND    closing_status = 'F'
    AND    start_date = (SELECT min(start_date)
                         FROM gl_period_statuses
                         WHERE  application_id = 101
                         AND    set_of_books_id = l_sob_id
                         AND    closing_status = 'F')
    ORDER BY effective_period_num ASC;
  BEGIN
    if p_sob_id is not null then
       l_sob_id := p_sob_id;
    else
       l_sob_id := fnd_profile.value('GL_SET_OF_BKS_ID');
    end if;

    OPEN get_latest_opened;
    FETCH get_latest_opened INTO default_period;

    IF get_latest_opened%FOUND THEN
      CLOSE get_latest_opened;
      return(default_period);
    ELSE
      CLOSE get_latest_opened;

      OPEN get_earliest_future_ent;
      FETCH get_earliest_future_ent INTO default_period;

      IF get_earliest_future_ent%FOUND THEN
        CLOSE get_earliest_future_ent;
        return(default_period);
      ELSE
        CLOSE get_earliest_future_ent;
        --fnd_message.set_name('SQLGL', 'GL_NO_OPEN_OR_FUTURE_PERIODS');
        return(null);
      END IF;
    END IF;
    return(null);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_default_actual_Period;

  --added by lijun 2010-08-10
  FUNCTION Get_Period_by_date(p_date IN date,
                              p_type in varchar2) RETURN VARCHAR2 IS
    l_Local_Function VARCHAR2(200) := 'CUX_UTIL_PKG.Get_Period_by_date';
    l_Year_Month     VARCHAR2(30);
    l_Year           VARCHAR2(30);
    l_Month          VARCHAR2(30);
    l_Quarter        VARCHAR2(30);
    l_period_meaning varchar2(30);
    l_period_name    varchar2(30);
  BEGIN
      SELECT To_Char(p.Start_Date, 'YYMM'),
           To_Char(p.Period_Year),
           To_Char(p.Period_Num),
           To_Char(p.Quarter_Num),
           p.period_name,
           p.period_year||'-'||lpad(p.period_num, 2, '0')
      INTO l_Year_Month,
           l_Year,
           l_Month,
           l_Quarter,
           l_period_name,
           l_period_meaning
      FROM Gl_Periods       p,
           Gl_Sets_Of_Books Sob
     WHERE Sob.Period_Set_Name = p.Period_Set_Name
       AND Sob.Set_Of_Books_Id = g_Sob_Id
       AND trunc(p_date) between nvl(trunc(p.start_date), trunc(p_date)-1)
                  and nvl(trunc(p.end_date), trunc(p_date) + 1)
       AND nvl(p.adjustment_period_flag,'N') = 'N';
       --added by lijun 2010-08-17
    IF p_Type = 'YEAR_MONTH' THEN
      RETURN(l_Year_Month);
    ELSIF p_Type = 'YEAR' THEN
      RETURN(l_Year);
    ELSIF p_Type = 'MONTH' THEN
      RETURN(l_Month);
    ELSIF p_Type = 'QUARTER' THEN
      RETURN(l_Quarter);
    ELSIF p_type = 'PERIOD_MEANING' then --added by lijun 2010-08-09
      return(l_period_meaning);
    ELSIF p_type = 'PERIOD_NAME' then
      return(l_period_name);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Period_by_date;

  FUNCTION Get_Period_Info(p_Period_Name IN VARCHAR2,
                           p_Type        IN VARCHAR2) RETURN VARCHAR2 IS
    l_Local_Function VARCHAR2(200) := 'CUX_UTIL_PKG.get_period_info';
    l_Year_Month     VARCHAR2(30);
    l_Year           VARCHAR2(30);
    l_Month          VARCHAR2(30);
    l_Quarter        VARCHAR2(30);
    l_period_meaning varchar2(30);
  BEGIN
    SELECT To_Char(p.Start_Date, 'YYMM'),
           To_Char(p.Period_Year),
           To_Char(p.Period_Num),
           To_Char(p.Quarter_Num),
           p.period_year||'-'||lpad(p.period_num, 2, '0')
      INTO l_Year_Month,
           l_Year,
           l_Month,
           l_Quarter,
           l_period_meaning
      FROM Gl_Periods       p,
           Gl_Sets_Of_Books Sob
     WHERE Sob.Period_Set_Name = p.Period_Set_Name
       AND Sob.Set_Of_Books_Id = g_Sob_Id
       AND p.Period_Name = p_Period_Name;
    IF p_Type = 'YEAR_MONTH' THEN
      RETURN(l_Year_Month);
    ELSIF p_Type = 'YEAR' THEN
      RETURN(l_Year);
    ELSIF p_Type = 'MONTH' THEN
      RETURN(l_Month);
    ELSIF p_Type = 'QUARTER' THEN
      RETURN(l_Quarter);
    ELSIF p_type = 'PERIOD_MEANING' then --added by lijun 2010-08-09
      return(l_period_meaning);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Period_Info;

   ------------------------------------------------------
  --获取期间说明
  FUNCTION Get_Period_Meaning(p_Period_Name IN VARCHAR2) RETURN VARCHAR2 AS
    l_Period_Name_Meaning VARCHAR2(100);
  BEGIN
    SELECT t.Period_Year || '-' || Lpad(t.Period_Num, 2, '0')
      INTO l_Period_Name_Meaning
      FROM Gl_Periods       t,
           Gl_Sets_Of_Books Sob
     WHERE Sob.Set_Of_Books_Id =
           Nvl(Fnd_Profile.VALUE('GL_SET_OF_BKS_ID'), 1001)
       AND Sob.Period_Set_Name = t.Period_Set_Name
       AND t.Period_Name = p_Period_Name
       AND Rownum < 2;
    RETURN(l_Period_Name_Meaning);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END Get_Period_Meaning;

  ----------------------------------------------------

  FUNCTION Get_Second_Org_Code(p_Org_Id          IN NUMBER,
                               p_Second_Org_Code IN VARCHAR2) RETURN VARCHAR2 IS
    l_Ou_Code    VARCHAR2(100);
    l_Second_Org VARCHAR2(100);
    l_company_code varchar2(100);
  BEGIN
    IF p_Second_Org_Code IS NOT NULL THEN
      RETURN(p_Second_Org_Code);
    END IF;

    l_company_code := get_comp_code(p_Org_Id);

    if l_company_code is not null then
       return(l_company_code);
    end if;

    SELECT Substr(Hou.NAME, 1, 2) || '01'
      INTO l_Ou_Code
      FROM Hr_Operating_Units Hou
     WHERE Hou.Organization_Id = p_Org_Id;
    RETURN(l_Ou_Code);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN('');
  END Get_Second_Org_Code;

  FUNCTION Get_Next_Number(p_Source          IN VARCHAR2,
                           p_Document_Prefix IN VARCHAR2) RETURN VARCHAR2 IS
    l_Max_Number  NUMBER;
    l_Next_Number VARCHAR2(30);
  BEGIN
    --execute immediate ('select count(*) from '|| v_owner ||'.'|| v_tname) into tcount;

    IF p_Source = 'CUX_EXPENSE_HEADERS_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Report_Num, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Expense_Headers_All
         WHERE Report_Num LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    ELSIF p_Source = 'CUX_EXPENSE_HEADERS_ALL_JK' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Report_Num, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Expense_Headers_All
         WHERE Report_Num LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    ELSIF p_Source = 'CUX_INVOICES_ALL_YF' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Invoice_Num, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Invoices_All
         WHERE Invoice_Num LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    ELSIF p_Source = 'CUX_INVOICES_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Invoice_Num, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Invoices_All
         WHERE Invoice_Num LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    ELSIF p_Source = 'CUX_PAY_HEADERS_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Pay_Number, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Pay_Headers_All
         WHERE Pay_Number LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    --ELSIF p_Source = 'CUX_PAY_APPLY_H_ALL' THEN
    ELSIF p_Source in ('CUX_PAY_APPLY_H_ALL',
                      'GL_JE_HEADERS_RC',
                      'GL_JE_HEADERS_JT') THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Apply_Number, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Pay_Apply_h_All
         WHERE Apply_Number LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    ELSIF p_Source = 'CUX_GL_IEA_TRANSACTIONS' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Apply_Number, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Pay_Apply_h_All
         WHERE Apply_Number LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
    ELSIF p_Source = 'CUX_GL_JE_HEADERS_CASH' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Apply_Number, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX.CUX_Pay_Apply_h_All
         WHERE Apply_Number LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
   /*  ELSIF p_Source = 'CUX_CHECK_STOCKS_ALL' THEN
     BEGIN
        SELECT MAX(To_Number(REPLACE(Check_Stock_Number, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_Check_Stocks_All
         WHERE Check_Stock_Number LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;
      --ADD BY PENG.SHENG 20100622
      --网银付款批
      --暂时取消，等网银发布时需要启用
   /* ELSIF p_Source = 'CUX_PAY_BATCH_H_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(Pay_Batch_Num, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_Pay_Batch_h_All a
         WHERE a.Pay_Batch_Num LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;*/
 /*   ELSIF
      p_Source = 'CUX_DOCUMENTS_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(document_num, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_DOCUMENTS_ALL
         WHERE document_num LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;*/ --added by lijun 2010-09-25
   /* ELSIF
      p_Source = 'CUX_AR_CASH_RECEIPTS_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(APPLY_NUMBER, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_Pay_Apply_h_All
         WHERE APPLY_NUMBER LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;*/ --added by lijun 2011-01-26
    /*ELSIF
      p_source = 'CUX_PAY_PLAN_B_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(PLAN_BATCH_NUM, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_PAY_PLAN_B_ALL
         WHERE PLAN_BATCH_NUM LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;*/ --added by lijun 2011-10-28
   /* ELSIF
      p_source = 'CUX_CHECK_PO_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(CHECK_PO_NUMBER, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_CHECK_PO_ALL
         WHERE CHECK_PO_NUMBER LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END; */--added by lijun 2012-07-28
  /*  ELSIF
      p_source = 'CUX_CHECK_APPLY_H_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(CHECK_APPLY_NUMBER, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_CHECK_APPLY_H_ALL
         WHERE CHECK_APPLY_NUMBER LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;*/ --added by lijun 2012-07-28
   /* ELSIF
      p_source = 'CUX_CHECK_DEL_H_ALL' THEN
      BEGIN
        SELECT MAX(To_Number(REPLACE(CHECK_DEL_NUMBER, p_Document_Prefix)))
          INTO l_Max_Number
          FROM CUX_CHECK_DEL_H_ALL
         WHERE CHECK_DEL_NUMBER LIKE p_Document_Prefix || '%';
      EXCEPTION
        WHEN OTHERS THEN
          l_Max_Number := NULL;
      END;*/ --added by lijun 2012-07-28
    END IF;

    IF l_Max_Number IS NULL THEN
      IF p_source in ('CUX_CHECK_PO_ALL',
                      'CUX_CHECK_APPLY_H_ALL',
                      'CUX_CHECK_DEL_H_ALL') THEN
        l_Next_Number := '00000001';
      ELSE
      l_Next_Number := '0001';
      END IF;
    ELSE
      IF p_source in ('CUX_CHECK_PO_ALL',
                      'CUX_CHECK_APPLY_H_ALL',
                      'CUX_CHECK_DEL_H_ALL') THEN
        l_Next_Number := Lpad(To_Char(l_Max_Number + 1), 8, '0');
      ELSE
      l_Next_Number := Lpad(To_Char(l_Max_Number + 1), 4, '0');
      END IF;
    END IF;
    RETURN(l_Next_Number);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Next_Number;

  FUNCTION Get_Document_Number(p_Source      IN VARCHAR2,
                               p_Period_Name IN VARCHAR2 DEFAULT NULL,
                               p_Date        IN DATE DEFAULT SYSDATE,
                               p_Parameter1  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter2  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter3  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter4  IN VARCHAR2 DEFAULT NULL,
                               p_Parameter5  IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_Error_Msg               VARCHAR2(2000);
    l_Local_Function          VARCHAR2(80) := 'get_document_number';
    l_Profile_Org_Id          NUMBER := Fnd_Profile.VALUE('ORG_ID');
    l_Profile_Second_Org_Code VARCHAR2(30) := Fnd_Profile.VALUE('CUX_SECU_SAME_COMPANY_CODE');
    l_Second_Org_Code         VARCHAR2(30);
    l_Document_Type           VARCHAR2(80);
    l_Document_Prefix         VARCHAR2(80);
    l_Document_Number         VARCHAR2(80);
    l_Year_Month              VARCHAR2(30);
    l_Max_Number              NUMBER;
    l_Next_Number             VARCHAR2(30);
  BEGIN
    l_Second_Org_Code := Get_Second_Org_Code(l_Profile_Org_Id,
                                             l_Profile_Second_Org_Code);
    IF p_Period_Name IS NOT NULL THEN
      l_Year_Month := Get_Period(p_Period_Name);
    END IF;

    IF l_Year_Month IS NULL THEN
      IF p_Date IS NOT NULL THEN
        l_Year_Month := To_Char(p_Date, 'YYMM');
      ELSE
        l_Year_Month := To_Char(SYSDATE, 'YYMM');
      END IF;
    END IF;

    IF p_Source = 'CUX_EXPENSE_HEADERS_ALL' THEN
      l_Document_Type := 'BX';
    ELSIF p_Source = 'CUX_EXPENSE_HEADERS_ALL_JK' THEN
      l_Document_Type := 'JK';
    ELSIF p_Source = 'CUX_INVOICES_ALL' THEN
      l_Document_Type := 'BZ';
    ELSIF p_Source = 'CUX_INVOICES_ALL_YF' THEN
      l_Document_Type := 'YF';
    ELSIF p_Source = 'CUX_PAY_HEADERS_ALL' THEN
      l_Document_Type := 'FK';
    ELSIF p_Source = 'CUX_PAY_APPLY_H_ALL' THEN
      l_Document_Type := 'SQ';
    ELSIF p_Source = 'CUX_CHECK_STOCKS_ALL' THEN
      l_Document_Type := 'ZP';
    ELSIF p_source = 'GL_JE_HEADERS_RC' THEN
      l_document_type := 'RC';
    ELSIF p_source = 'GL_JE_HEADERS_JT' THEN
      l_document_type := 'JT';

      --ADD BY PENG.SHENG 20100622
      --网银付款批
    ELSIF p_Source = 'CUX_PAY_BATCH_H_ALL' THEN
      l_Document_Type := 'FKP';
    ELSIF p_source = 'CUX_DOCUMENTS_ALL' THEN
      l_Document_Type := 'FP';
    ELSIF P_SOURCE = 'CUX_GL_IEA_TRANSACTIONS' THEN
      if p_Parameter1 = 'JZ' THEN
      l_Document_Type := 'JZ'; --added by lijun 2012-04-26
      ELSIF p_Parameter1 = 'NW' THEN
      l_Document_Type := 'NW';
      ELSE
      l_Document_Type := 'BK';
      END IF;
    ELSIF P_SOURCE = 'CUX_GL_JE_HEADERS_CASH' then
      l_Document_Type := 'XJ';--ADDed by lijun 2010-10-20
    ELSIF P_SOURCE = 'CUX_AR_CASH_RECEIPTS_ALL' then
      l_document_type := 'SK';--added by lijun 2011-01-26
    ELSIF p_source = 'CUX_PAY_PLAN_B_ALL' then
      l_document_type := 'SD';
    ELSIF p_source = 'CUX_CHECK_PO_ALL' then
      l_document_type := 'ZPCG';
    ELSIF p_source = 'CUX_CHECK_APPLY_H_ALL' then
      l_document_type := 'ZPLY';
    ELSIF p_source = 'CUX_CHECK_DEL_H_ALL' then
      l_document_type := 'ZPZF';
    END IF;

    IF l_Second_Org_Code IS NULL
       OR l_Document_Type IS NULL
       OR l_Year_Month IS NULL THEN
      RETURN(NULL);
    END IF;

    IF P_SOURCE = 'CUX_GL_IEA_TRANSACTIONS' THEN
       l_Document_Prefix := l_Document_Type ||
                         l_Year_Month;
    ELSIF P_SOURCE IN ('CUX_CHECK_PO_ALL',
                       'CUX_CHECK_APPLY_H_ALL',
                       'CUX_CHECK_DEL_H_ALL'
                       ) THEN
       l_Document_Prefix := l_Second_Org_Code||l_Document_Type;
    ELSE
       l_Document_Prefix := l_Second_Org_Code || l_Document_Type ||
                         l_Year_Month;
    END IF;

    l_Next_Number := Get_Next_Number(p_Source, l_Document_Prefix);

    IF l_Document_Prefix IS NULL
       OR l_Next_Number IS NULL THEN
      RETURN(NULL);
    END IF;

    l_Document_Number := l_Document_Prefix || l_Next_Number;
    RETURN(l_Document_Number);

  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Document_Number;

  ------------------------------------------------------------------------------------
  PROCEDURE Get_Ccid_p(p_All_Segments IN VARCHAR2,
                       p_Ccid         OUT NUMBER,
                       p_Error_Msg    OUT VARCHAR2) IS
    l_Chart_Of_Accounts_Id NUMBER;
    l_Ccid                 NUMBER;
    l_Valid_Combination    BOOLEAN;
    l_Cr_Combination       BOOLEAN;
  BEGIN

    BEGIN
      SELECT Chart_Of_Accounts_Id
        INTO l_Chart_Of_Accounts_Id
        FROM Gl_Sets_Of_Books Sob
       WHERE Sob.Set_Of_Books_Id = Fnd_Profile.VALUE('GL_SET_OF_BKS_ID');

    EXCEPTION
      WHEN OTHERS THEN
        p_Error_Msg := 'Error while getting chart of account';
    END;

    l_Valid_Combination := Fnd_Flex_Keyval.Validate_Segs(Operation        => 'CHECK_COMBINATION',
                                                         Appl_Short_Name  => 'SQLGL',
                                                         Key_Flex_Code    => 'GL#',
                                                         Structure_Number => l_Chart_Of_Accounts_Id,
                                                         Concat_Segments  => p_All_Segments);
    IF l_Valid_Combination THEN
            l_cr_combination := FND_FLEX_KEYVAL.validate_segs(
      operation        => 'CREATE_COMBINATION',
      appl_short_name  => 'SQLGL',
      key_flex_code    => 'GL#',
      structure_number => l_chart_of_accounts_id,
      concat_segments  => p_all_segments );
      NULL;
    ELSE
      p_Ccid      := null;
      p_Error_Msg := Fnd_Flex_Keyval.Error_Message();
    END IF;

    l_Ccid := Fnd_Flex_Ext.Get_Ccid(Application_Short_Name => 'SQLGL',
                                    Key_Flex_Code          => 'GL#',
                                    Structure_Number       => l_Chart_Of_Accounts_Id,
                                    Validation_Date        => To_Char(SYSDATE,
                                                                      'YYYY/MM/DD HH24:MI:SS'),
                                    Concatenated_Segments  => p_All_Segments);
    if l_ccid in (0,-1) then
      p_ccid := null;
    else
      p_Ccid := l_Ccid;
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      p_Error_Msg := SQLERRM;
  END Get_Ccid_p;

  --==============================================
  -- Procedure:
  --
  -- Purpose:
  --   值集屏蔽
  --==============================================
  FUNCTION Value_Set_Security(p_Security_Check_Mode IN VARCHAR2,
                              p_Flex_Value_Set_Id   IN NUMBER,
                              p_Parent_Flex_Value   IN VARCHAR2,
                              p_Flex_Value          IN VARCHAR2,
                              p_Resp_Application_Id IN NUMBER,
                              p_Responsibility_Id   IN NUMBER)
    RETURN VARCHAR2 IS
    l_Error_Msg       VARCHAR2(2000);
    l_Security_Status VARCHAR2(100);
    l_Error_Message   VARCHAR2(2000);
  BEGIN
    Fnd_Flex_Server.Check_Value_Security(p_Security_Check_Mode, --Y,
                                         p_Flex_Value_Set_Id, --1010936,
                                         p_Parent_Flex_Value, --''
                                         p_Flex_Value, --'0101',
                                         p_Resp_Application_Id, --101,
                                         p_Responsibility_Id, --50237,
                                         l_Security_Status,
                                         l_Error_Message);
    IF l_Security_Status = 'NOT-SECURED' THEN
      RETURN('Y');
    ELSE
      RETURN('N');
    END IF;
    --DBMS_OUTPUT.PUT_LINE(L_SECURITY_STATUS);
    --'NOT-SECURED'
    --DBMS_OUTPUT.PUT_LINE(l_error_message);
  EXCEPTION
    WHEN OTHERS THEN
      l_Error_Msg := SQLERRM;
      RETURN('N');
  END Value_Set_Security;

  --检验段值安全性
  FUNCTION Check_Segment_Security(p_Segment       IN VARCHAR2,
                                  p_Segment_Value IN VARCHAR2)
    RETURN VARCHAR2 IS

    v_Flexset_Id   NUMBER;
    v_Flag         VARCHAR2(20);
    v_Resp_Appl_Id NUMBER := Fnd_Profile.VALUE('Resp_Appl_Id');
    v_Resp_Id      NUMBER := Fnd_Profile.VALUE('Resp_Id');

  BEGIN
    SELECT t.Flex_Value_Set_Id
      INTO v_Flexset_Id
      FROM Fnd_Id_Flex_Segments_Vl t
     WHERE t.Id_Flex_Code = 'GL#'
       AND t.Id_Flex_Num = 50308
       AND t.Application_Column_Name = p_Segment
       AND t.Application_Id = 101;

    v_Flag := CUX_Util_Pkg.Value_Set_Security(p_Security_Check_Mode => 'Y',
                                                  p_Flex_Value_Set_Id   => v_Flexset_Id,
                                                  p_Parent_Flex_Value   => '',
                                                  p_Flex_Value          => p_Segment_Value,
                                                  p_Resp_Application_Id => v_Resp_Appl_Id,
                                                  p_Responsibility_Id   => v_Resp_Id);
    RETURN v_Flag;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'N';
  END Check_Segment_Security;

  function get_dff_column_name(p_flex_value_set_name in varchar2,
                               p_column_name in varchar2) return varchar2 is
  l_application_column_name FND_DESCR_FLEX_COL_USAGE_VL.APPLICATION_COLUMN_NAME%type;
  begin
     select dc.application_column_name
     INTO l_application_column_name
     from FND_DESCR_FLEX_COL_USAGE_VL dc
     where dc.APPLICATION_ID = 0
     and dc.DESCRIPTIVE_FLEXFIELD_NAME LIKE 'FND_FLEX_VALUES'
     and dc.DESCRIPTIVE_FLEX_CONTEXT_CODE = p_flex_value_set_name
     and dc.application_column_name = p_column_name
     and rownum < 2;
     return(l_application_column_name);
  exception
  when others then
     return(NULL);
  END get_dff_column_name;

  function check_period_range (p_period in varchar2,
                           p_period_from in varchar2,
                           p_period_to in varchar2) return varchar2 is
     l_count number := 0;
     l_period_set_name gl_sets_of_books.period_set_name%type;
  begin
     select period_set_name
     into l_period_set_name
     from gl_sets_of_books sob
     where sob.set_of_books_id = g_Sob_Id;

     SELECT
        count(1)
     into
        l_count
     FROM gl_periods p, gl_periods p1, gl_periods p2
     WHERE p.period_set_name = l_period_set_name
       AND p.period_name = p_period
       AND p1.period_set_name = l_period_set_name
       and p1.period_name = p_period_from
       and p2.period_set_name = l_period_set_name
       and p2.period_name = p_period_to
       and (p.period_year > p1.period_year or
            (p.period_year = p1.period_year and
            p.period_num >= p1.period_num))
       and (p.period_year < p2.period_year or
            (p.period_year = p2.period_year and
            p.period_num <= p2.period_num));
     if l_count > 0 then
        return('Y');
     else
        return('N');
     end if;
  exception
  when others then
     return('N');
  end check_period_range;

  FUNCTION Get_Ccid_Segments(p_Ccid IN NUMBER) RETURN VARCHAR2 IS
    l_Ccid_Segments VARCHAR2(2000);
  BEGIN
    SELECT Concatenated_Segments
      INTO l_Ccid_Segments
      FROM Gl_Code_Combinations_Kfv Gcc
     WHERE Code_Combination_Id = p_Ccid;
    RETURN l_Ccid_Segments;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Ccid_Segments;

  FUNCTION Get_Ccid_Desc(p_Appl_Short_Name IN VARCHAR2 DEFAULT NULL,
                         p_Id_Flex_Code    IN VARCHAR2 DEFAULT NULL,
                         p_Id_Flex_Num     IN NUMBER DEFAULT NULL,
                         p_Ccid            IN NUMBER) RETURN VARCHAR2 IS
    RESULT VARCHAR2(2000);

    TYPE Descarray IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
    l_Desc_Array Descarray;
    l_Seg_Array  Fnd_Flex_Ext.Segmentarray;
    l_Nsegs      NUMBER;
    l_Sts        BOOLEAN;
    l_Conc_Desc  VARCHAR2(2000);
    l_Delimiter  VARCHAR2(10);

    l_Appl_Short_Name Fnd_Application.Application_Short_Name%TYPE;
    l_Id_Flex_Code    Fnd_Id_Flex_Segments_Vl.Id_Flex_Code%TYPE;
    l_Id_Flex_Num     Fnd_Id_Flex_Segments_Vl.Id_Flex_Num%TYPE;

    CURSOR Cur_Set IS
      SELECT Rownum Num,
             Ffs.Segment_Name,
             Ffs.Segment_Num,
             Ffs.Flex_Value_Set_Id
        FROM Fnd_Id_Flex_Segments_Vl Ffs
       WHERE Ffs.Id_Flex_Code = l_Id_Flex_Code
         AND Ffs.Id_Flex_Num = l_Id_Flex_Num;

  BEGIN
    IF p_Appl_Short_Name IS NOT NULL THEN
      l_Appl_Short_Name := 'SQLGL';
    END IF;

    IF p_Id_Flex_Code IS NOT NULL THEN
      l_Id_Flex_Code := 'GL#';
    END IF;

    IF p_Id_Flex_Num IS NOT NULL THEN
      BEGIN
        SELECT Sob.Chart_Of_Accounts_Id
          INTO l_Id_Flex_Num
          FROM Gl_Sets_Of_Books Sob
         WHERE Sob.Set_Of_Books_Id = Fnd_Profile.VALUE('GL_SETS_OF_BKS_ID');
      EXCEPTION
        WHEN OTHERS THEN
          l_Id_Flex_Num := 50308;
      END;
    ELSE
      l_Id_Flex_Num := p_Id_Flex_Num;
    END IF;

    l_Delimiter := Fnd_Flex_Ext.Get_Delimiter(Application_Short_Name => p_Appl_Short_Name,
                                              Key_Flex_Code          => p_Id_Flex_Code,
                                              Structure_Number       => p_Id_Flex_Num);
    Fnd_Flex_Ext.Clear_Ccid_Cache;
    l_Sts := Fnd_Flex_Ext.Get_Segments(Application_Short_Name => p_Appl_Short_Name,
                                       Key_Flex_Code          => p_Id_Flex_Code,
                                       Structure_Number       => p_Id_Flex_Num,
                                       Combination_Id         => p_Ccid,
                                       n_Segments             => l_Nsegs,
                                       Segments               => l_Seg_Array);
    IF NOT l_Sts THEN
      RESULT := Fnd_Flex_Ext.Get_Message;
      RETURN(NULL);
    END IF;

    FOR Rec_Set IN Cur_Set
    LOOP
      BEGIN
        SELECT Ffv.Description
          INTO l_Desc_Array(Rec_Set.Num)
          FROM Fnd_Flex_Values_Vl Ffv
         WHERE Ffv.Flex_Value_Set_Id = Rec_Set.Flex_Value_Set_Id
           AND Ffv.Flex_Value = l_Seg_Array(Rec_Set.Num);

      EXCEPTION
        WHEN OTHERS THEN
          l_Desc_Array(Rec_Set.Num) := NULL;
      END;
      SELECT l_Conc_Desc || Decode(l_Conc_Desc, NULL, NULL, l_Delimiter) ||
             l_Desc_Array(Rec_Set.Num)
        INTO l_Conc_Desc
        FROM Dual;
    END LOOP;

    RESULT := l_Conc_Desc;

    RETURN(RESULT);

  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_Ccid_Desc;


  ------------------------------------------------------
  --获取组织公司代码
  FUNCTION Get_Comp_Code(p_Org_Id IN NUMBER) RETURN VARCHAR2 AS
    v_Comp        VARCHAR2(100);
    v_Flex_Set_Id NUMBER;

  BEGIN
/*    SELECT t.Flex_Value_Set_Id
      INTO v_Flex_Set_Id
      FROM Fnd_Id_Flex_Segments_Vl t
     WHERE t.Id_Flex_Code = 'GL#'
       AND t.Application_Column_Name = 'SEGMENT1'
       AND t.Application_Id = 101
       AND Rownum = 1;*/
      select i.flex_value_set_id
      into v_Flex_Set_Id
      from Fnd_Id_Flex_Segments_Vl i,
           gl_sets_of_books sob
      where i.ID_FLEX_NUM = sob.chart_of_accounts_id
      AND i.Application_Column_Name = 'SEGMENT1'
      and sob.set_of_books_id = g_Sob_Id
      and rownum < 2;

    SELECT t.Flex_Value
      INTO v_Comp
      FROM Fnd_Flex_Values_Vl t
     WHERE (t.Flex_Value_Set_Id = v_Flex_Set_Id)
          --AND t.Value_Category = 'CUX_ORG'
       AND t.Attribute1 = To_Char(p_Org_Id);

    RETURN v_Comp;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END Get_Comp_Code;

  ------------------------------------------------------
  --获取父公司代码
  --added by lijun 2010-08-17
  FUNCTION Get_parent_Comp_Code(p_company_code IN varchar2,
                                p_type in varchar2)
  RETURN VARCHAR2 AS
    l_parent_comp        VARCHAR2(100);
    l_parent_comp_meaning varchar2(100);
    l_Flex_Set_Id NUMBER;

  BEGIN
/*    SELECT t.Flex_Value_Set_Id
      INTO l_Flex_Set_Id
      FROM Fnd_Id_Flex_Segments_Vl t
     WHERE t.Id_Flex_Code = 'GL#'
       AND t.Application_Column_Name = 'SEGMENT1'
       AND t.Application_Id = 101
       AND Rownum = 1;*/
      select i.flex_value_set_id
      into l_Flex_Set_Id
      from Fnd_Id_Flex_Segments_Vl i,
           gl_sets_of_books sob
      where i.ID_FLEX_NUM = sob.chart_of_accounts_id
      AND i.Application_Column_Name = 'SEGMENT1'
      and sob.set_of_books_id = g_Sob_Id
      and rownum < 2;

    SELECT t.attribute2
      INTO l_parent_comp
      FROM Fnd_Flex_Values_Vl t
     WHERE (t.Flex_Value_Set_Id = l_Flex_Set_Id)
       AND t.flex_value = p_company_code;

    if p_type = 'CODE' then
       return(l_parent_comp);
    elsif p_type = 'MEANING' then
       select description
       into l_parent_comp_meaning
       from fnd_flex_values_vl
       where Flex_Value_Set_Id = l_Flex_Set_Id
       and flex_value = l_parent_comp;
       return(l_parent_comp_meaning);
    end if;

    RETURN l_parent_comp;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END Get_parent_Comp_Code;

  ------------------------------------------------------
  --获取组织公司代码
  FUNCTION Get_Org_Id(p_Comp_Code IN VARCHAR2) RETURN NUMBER AS
    v_Attribute1  VARCHAR2(150);
    v_Org_Id      NUMBER;
    v_Flex_Set_Id NUMBER;

  BEGIN
/*    SELECT t.Flex_Value_Set_Id
      INTO v_Flex_Set_Id
      FROM Fnd_Id_Flex_Segments_Vl t
     WHERE t.Id_Flex_Code = 'GL#'
       AND t.Application_Column_Name = 'SEGMENT1'
       AND t.Application_Id = 101
       AND Rownum = 1;*/
    select i.flex_value_set_id
      into v_Flex_Set_Id
      from Fnd_Id_Flex_Segments_Vl i,
           gl_sets_of_books sob
      where i.ID_FLEX_NUM = sob.chart_of_accounts_id
      AND i.Application_Column_Name = 'SEGMENT1'
      and sob.set_of_books_id = g_Sob_Id
      and rownum < 2;

    SELECT t.Attribute1
      INTO v_Attribute1
      FROM Fnd_Flex_Values_Vl t
     WHERE (t.Flex_Value_Set_Id = v_Flex_Set_Id)
          --AND t.Value_Category = 'CUX_ORG'
       AND t.Flex_Value = p_Comp_Code;

    v_Org_Id := To_Number(v_Attribute1);

    RETURN v_Org_Id;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END Get_Org_Id;


  FUNCTION Get_User_Employee_Id(p_User_Id IN NUMBER) RETURN NUMBER IS
    l_Employee_Id NUMBER;
  BEGIN
    SELECT Employee_Id
      INTO l_Employee_Id
      FROM Fnd_User
     WHERE User_Id = p_User_Id;
    RETURN(l_Employee_Id);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_User_Employee_Id;

  FUNCTION Get_User_Employee_name(p_User_Id IN NUMBER,
                                  p_type in varchar2)
  RETURN varchar2 IS
    l_Employee_Id NUMBER;
    l_employee_number per_all_people_f.employee_number%type;
    l_full_name per_all_people_f.full_name%type;
    l_user_name fnd_user.user_name%type;
  BEGIN
    SELECT Employee_Id,
           user_name
      INTO l_Employee_Id,
           l_user_name
      FROM Fnd_User
     WHERE User_Id = p_User_Id;

     if p_type = 'EMPLOYEE_ID' then
       return(l_Employee_Id);
     end if;

     if l_employee_id is not null then
       select employee_number,
             full_name
       into l_employee_number,
            l_full_name
       from per_all_people_f ppf
       where ppf.person_id = l_Employee_Id
       and sysdate between effective_start_date
                   and effective_end_date
       and rownum < 2;
     else
       l_full_name := l_user_name;
     end if;

     if p_type = 'EMPLOYEE_NUMBER' then
        RETURN(l_employee_number);
     ELSif p_type = 'EMPLOYEE_NAME' then
        RETURN(l_full_name);
     else
        return(l_full_name);
     end if;
     return(null);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(NULL);
  END Get_User_Employee_name;

END CUX_Util_Pkg;
/
