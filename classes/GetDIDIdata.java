package com.rh.core.input;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.security.MessageDigest;

import org.json.JSONArray;

import java.sql.DriverManager;

import org.json.JSONException;
import org.json.JSONObject;

import com.rh.core.input.*;

import oracle.jdbc.driver.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;

public class GetDIDIdata {
	static Connection con = null;
	static Statement st = null;

	public static String getSha1(String str) {

	//这里是加解密函数抱歉不能显示给大家看到
	}

	public static String GetDIDIrequestDATA(String p_period_name, String reqid,
			String org_id, String APPID1, String companycode, String Version,
			String Userid, String LoginId, String requestid,
			String connectstring, String appspw) throws Exception

	{
		String jsondata = null;
		int lineid = 0;
		int incid = 0;
		int insertcount = 0;
		// String APPID = "100417001";
		String SECURITY_KEY = "1eb11e19ad9745e8b1618f13a751bd6963cb5d37619d47baa71e8bbc6813152de5f07b629c3e4b7a8ea2c4a7cefa50ae90d89bfd9a034734882f784e56cd6e09";
		try {

			con = null;// 创建一个数据库连接
			// PreparedStatement pre = null;// 创建预编译语句对象，一般都是用这个而不用Statement

			String driverName = "oracle.jdbc.driver.OracleDriver";

			Class.forName(driverName);// 加载Oracle驱动程序
			System.out.println("开始尝试连接数据库！");
			// String url = "jdbc:oracle:" + "thin:@172.20.21.76:1541:UAT";
			String urlw = "jdbc:oracle:" + connectstring;// "thin:@172.20.24.52:1521:HTWDEV";
			String user = "apps";// 用户名,系统默认的账户名
			String password = "apps";// "apps";// 你安装时选设置的密码
			try {
				con = DriverManager.getConnection(urlw, user, password);// 获取连接
				System.out.println("连接成功！");
				st = con.createStatement();

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("连接失败!");

			}

			// int reqid=getreqid();

			for (int page = 0; page < 20000;)

			{

				long times = System.currentTimeMillis();
				String sign = getSha1(APPID1 + SECURITY_KEY + times);
				String url1 = "https://mdata.didichuxing.com/gateway/hr-basic/openApi/V3/voucher/list/query?prdId="
						+ p_period_name
						+ "&companyCode="
						+ companycode
						+ "&start=" + page + "&size=50";
				URL url = new URL(url1);
				HttpURLConnection connection = (HttpURLConnection) url
						.openConnection();
				connection.setRequestProperty("Ver", Version);
				connection.setRequestProperty("AppId", APPID1);
				connection.setRequestProperty("Timestamp",
						String.valueOf(times));

				connection.setRequestProperty("Signature", sign);
				connection.connect();// 连接会话
				// 获取输入流
				BufferedReader br = new BufferedReader(new InputStreamReader(
						connection.getInputStream(), "UTF-8"));
				String line;
				StringBuilder sb = new StringBuilder();
				while ((line = br.readLine()) != null) {// 循环读取流
					sb.append(line);
				}
				System.out.println(sb.toString());
				JSONObject jsonObject = new JSONObject(sb.toString());

				String data = jsonObject.getString("data");

				if (data.equals("[]")) {
					return String.valueOf(insertcount);
				}
				JSONArray jsonArray = new JSONArray(data);

				for (int x = 0; x < jsonArray.length(); x++) {
					JSONObject jsonobject2 = jsonArray.getJSONObject(x);
					String EBS_Deptno = null;
					String companyCode = jsonobject2.getString("companyCode");
					String deptId = jsonobject2.getString("deptId");
					String currency = jsonobject2.getString("currency");
					String collect = jsonobject2.getString("collect");
					String period_name = jsonobject2.getString("prdId");
					String salaryAttr = jsonobject2.getString("salaryAttr");
					String EBS_companyCode = getEBScompanycode(companyCode,
							deptId);
					String EBS_DR_subject = getEBSDRSUBJECT(salaryAttr, collect);
					String EBS_CR_subject = getEBSCRSUBJECT(collect);
					String EBS_ledgerid = getEBSledgerid(EBS_companyCode);
					String Amount = jsonobject2.getString("amount");
					String city_code = getEBSCITYCODE(deptId);
					String User_Je_category_Name = getUser_Je_category_Name(collect);
					String Reverse_Process = getPSIFreverse(collect);

					// 获取成本中心
					if (getPSIFexpense(collect) != null) {
						if (getPSIFexpense(collect).equals("1")) {

							EBS_Deptno = getEBSdeptno(deptId);

						} else if (getPSIFexpense(collect).equals("0")) {
							EBS_Deptno = "0";
						}
					} else {
						EBS_Deptno = "找不到成本中心对应费用";
					}
					// 获取orgid
					String org_id1 = org_id;
					if (EBS_companyCode != null) {

						String sqlstr = "select hou.organization_id from APPS.Hr_Operating_Units hou where hou.short_code='"
								+ EBS_companyCode + "'";
						ResultSet rst = st.executeQuery(sqlstr);

						if (rst.next()) {

							{
								org_id1 = rst.getString(1);
							}
						}

					}
					;

					if ((EBS_companyCode == null)
							|| (EBS_companyCode.equals(""))) {
						org_id1 = null;
					}
					try {
						incid = incid + 1;
						lineid = incid;

						String sql = "insert into cux.CUX_GL_IMPORT_LINES_ALL (Reverse_Process,line_id,org_id,source_code,req_id,Request_id,user_je_category_name,Status,Creation_Date,Created_By,Last_Update_Date,Last_Updated_By,Last_Update_Login,User_Je_Source_Name,gl_date,ledger_id,CCID_segment1,ccid_segment2,ccid_segment3,ps_segment1,ps_segment2,currency_code,collect,period_name,expense_desc,ccid_segment4,ccid_segment5,ccid_segment6,ccid_segment7,ccid_segment8,ccid_segment9,ccid_segment10,entered_dr,accounted_dr,city_no) values("
								+ Reverse_Process
								+ ","
								+ lineid
								+ ","
								+ org_id1
								+ ","
								+ "'A'"
								+ ","
								+ reqid
								+ ","
								+ requestid
								+ ","
								+ "'"
								+ User_Je_category_Name
								+ "'"
								+ ","

								+ "'A'"
								+ ","
								+ "SYSDATE,"
								+ Userid
								+ ","
								+ "SYSDATE,"
								+ Userid
								+ ","
								+ LoginId
								+ ",'"
								+ "PS系统"

								+ "',last_day(to_date('"
								+ p_period_name
								+ "','YYYY-MM')),"
								+ EBS_ledgerid
								+ ","
								+ EBS_companyCode
								+ ",'"
								+ EBS_Deptno
								+ "',"
								+ EBS_DR_subject
								+ ","
								+ companyCode
								+ ","
								+ deptId
								+ ",'"
								+ currency
								+ "','"
								+ collect
								+ "','"
								+ period_name
								+ "','"
								+ salaryAttr
								+ "','0','0','0','0','0','0','0',"
								+ Amount
								+ "," + Amount + ",'" + city_code + "')";
						// System.out.println(sql);
						int f = st.executeUpdate(sql);
						incid = incid + 1;
						lineid = incid;
						String sql1 = "insert into cux.CUX_GL_IMPORT_LINES_ALL (Reverse_Process,line_id,org_id,source_code,req_id,Request_id,user_je_category_name,Status,Creation_Date,Created_By,Last_Update_Date,Last_Updated_By,Last_Update_Login,User_Je_Source_Name,gl_date,ledger_id,CCID_segment1,ccid_segment2,ccid_segment3,ps_segment1,ps_segment2,currency_code,collect,period_name,expense_desc,ccid_segment4,ccid_segment5,ccid_segment6,ccid_segment7,ccid_segment8,ccid_segment9,ccid_segment10,entered_cr,accounted_cr,city_no) values("
								+ Reverse_Process
								+ ","
								+ lineid
								+ ","
								+ org_id1
								+ ","
								+ "'A'"
								+ ","
								+ reqid
								+ ","
								+ requestid
								+ ","
								+ "'"
								+ User_Je_category_Name
								+ "'"
								+ ","
								+ "'A'"
								+ ","
								+ "SYSDATE,"
								+ Userid
								+ ","
								+ "SYSDATE,"
								+ Userid
								+ ","
								+ LoginId
								+ ",'"
								+ "PS系统"

								+ "',last_day(to_date('"
								+ p_period_name
								+ "','YYYY-MM')),"
								+ EBS_ledgerid
								+ ","
								+ EBS_companyCode
								+ ",'"
								+ "0"
								+ "',"
								+ EBS_CR_subject
								+ ","
								+ companyCode
								+ ","
								+ deptId
								+ ",'"
								+ currency
								+ "','"
								+ collect
								+ "','"
								+ period_name
								+ "','"
								+ salaryAttr
								+ "','0','0','0','0','0','0','0',"
								+ Amount
								+ "," + Amount + ",'" + city_code + "')";

						int w = st.executeUpdate(sql1);

						insertcount = insertcount + 2;
					} catch (Exception e) {
						e.printStackTrace();
					}

				}

				page = page + 50;

				br.close();// 关闭流
				connection.disconnect();// 断开连接

				jsondata = sb.toString();
				// return jsondata;

			}

			if (st != null) {
				st.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("失败!");
			return "失败";
		}

		return String.valueOf(insertcount);

	}

	public static String getPSIFexpense(String collect_code) throws Exception {

		String sqlstr = "select cpm.Issellingexpense from cux.cux_mdm_payment_mapping_t cpm where cpm.Collect_Code='"
				+ collect_code + "'";
		ResultSet rst = st.executeQuery(sqlstr);

		if (rst.next()) {
			return rst.getString(1);

		} else {
			return null;
		}

	}

	public static String getPSIFreverse(String collect_code) throws Exception {

		String sqlstr = "select cpm.Reversehandle from cux.cux_mdm_payment_mapping_t cpm where cpm.Collect_Code='"
				+ collect_code + "'";
		ResultSet rst = st.executeQuery(sqlstr);

		if (rst.next()) {
			return rst.getString(1);
		} else {
			return null;
		}
	}

	public static int getreqid() throws Exception {

		String sqlstr = "select    CUX_Batches_s.NEXTVAL   FROM Dual";
		ResultSet rst = st.executeQuery(sqlstr);

		if (rst.next()) {
			return rst.getInt(1);

		} else {
			return 0;
		}

	}

	public static String getEBSCRSUBJECT(String collect_code) throws Exception {

		String sqlstr = "select cpm.Creditsubject from cux.cux_mdm_payment_mapping_t cpm where cpm.Collect_Code='"
				+ collect_code + "'";
		ResultSet rst = st.executeQuery(sqlstr);
		if (rst.next()) {
			return rst.getString(1);
		} else {
			return null;
		}
	}

	public static String getEBSDRSUBJECT(String expense_desc,
			String collect_code) throws Exception {
		if (expense_desc.equals("AD")) {

			String sqlstr = "select cpm.Debtoradminexp from cux.cux_mdm_payment_mapping_t cpm where cpm.Collect_Code='"
					+ collect_code + "'";
			ResultSet rst = st.executeQuery(sqlstr);
			if (rst.next()) {
				return rst.getString(1);
			} else {
				return null;
			}
		} else if (expense_desc.equals("SE")) {

			String sqlstr = "select cpm.Debtorsellingexpense from cux.cux_mdm_payment_mapping_t cpm where cpm.Collect_Code='"
					+ collect_code + "'";
			ResultSet rst = st.executeQuery(sqlstr);
			if (rst.next()) {
				return rst.getString(1);
			} else {
				return null;
			}
		} else if (expense_desc.equals("RE")) {

			String sqlstr = "select cpm.Debtordevelopmentexpense from cux.cux_mdm_payment_mapping_t cpm where cpm.Collect_Code='"
					+ collect_code + "'";
			ResultSet rst = st.executeQuery(sqlstr);

			if (rst.next()) {
				return rst.getString(1);
			} else {
				return null;
			}
		}
		return null;
	}

	public static String getEBScompanycode(String PScompanycode, String PSdeptno)
			throws Exception {
		String ret = null;
		String sqlstr1 = "select d_Dept_Descr2 from cux.cux_mdm_dept_info where deptid="
				+ PSdeptno + "";
		ResultSet rst1 = st.executeQuery(sqlstr1);
		if (rst1.next()) {
			String description = rst1.getString(1);
			if ((description != "HM") & (description != "HT")) {
				description = "HM";
			}
			;
			String sqlstr = "select MEANING from APPLSYS.Fnd_Lookup_Values flv where flv.TAG="
					+ PScompanycode
					+ " and flv.DESCRIPTION='"
					+ description
					+ "'";
			// System.out.println(sqlstr);
			ResultSet rst = st.executeQuery(sqlstr);

			if (rst.next()) {
				ret = rst.getString(1);

			} else {
				ret = "null";
			}
		}
		return ret;

	}

	public static String getEBSdeptno(String PSdeptno) throws Exception {

		String sqlstr = "select D_COST_CENTER from cux.cux_mdm_dept_info where deptid="
				+ PSdeptno + "";
		ResultSet rst = st.executeQuery(sqlstr);

		if (rst.next()) {
			return rst.getString(1);
		} else {
			return "找不到成本中心";
		}
	}

	public static String getEBSCITYCODE(String PSdeptno) throws Exception {

		String sqlstr = "select D_CITY_CODE from cux.cux_mdm_dept_info where deptid="
				+ PSdeptno + "";
		ResultSet rst = st.executeQuery(sqlstr);

		if (rst.next()) {
			return rst.getString(1);
		} else {
			return "null";
		}
	}

	public static String getEBSledgerid(String EBScompanycode) throws Exception {

		String sqlstr = "select set_of_books_id from APPS.Hr_Operating_Units hou where hou.short_code='"
				+ EBScompanycode + "'";
		ResultSet rst = st.executeQuery(sqlstr);

		if (rst.next()) {
			return rst.getString(1);
		} else {
			return "2021";
		}

	}

	/*
	 * public static String getlineid(String reqid) throws Exception { {
	 * 
	 * return reqid+1 return "获取行ID失败"; }
	 * 
	 * }
	 */
	public static String getUser_Je_category_Name(String collect_code)
			throws Exception {
		String ret = null;
		String sqlstr = "select cpm.Vouchercategory from cux.cux_mdm_payment_mapping_t cpm where rownum=1 and cpm.Collect_Code='"
				+ collect_code + "'";
		ResultSet rst = st.executeQuery(sqlstr);
		if (rst.next()) {
			String lookupcode = rst.getString(1);
			String sqlstr1 = "select flv.MEANING from APPLSYS.Fnd_Lookup_Values flv where flv.LOOKUP_TYPE  = 'CUX_HR_JOURCATE_MAPPING' AND FLV.LANGUAGE='ZHS' AND flv.LOOKUP_code='"
					+ lookupcode + "'";
			ResultSet rst1 = st.executeQuery(sqlstr1);
			if (rst1.next()) {
				ret = rst1.getString(1);
			}
			return ret;
		} else {
			return "找不到类别";
		}
	}

	public static String sendPost(String url, String param) {
		PrintWriter out = null;
		BufferedReader in = null;
		String result = "";
		try {
			URL realUrl = new URL(url);
			// 打开和URL之间的连接
			URLConnection conn = realUrl.openConnection();
			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// 获取URLConnection对象对应的输出流
			out = new PrintWriter(conn.getOutputStream());
			// 发送请求参数
			out.print(param);
			// flush输出流的缓冲
			out.flush();
			// 定义BufferedReader输入流来读取URL的响应
			in = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			System.out.println("发送 POST 请求出现异常！" + e);
			e.printStackTrace();
		}
		// 使用finally块来关闭输出流、输入流
		finally {
			try {
				if (out != null) {
					out.close();
				}
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}

	public static void main(String[] args) throws Exception {

		System.out.println(GetDIDIrequestDATA("2018-07", "1112", "81",
				"100502001", "135", "V3", "1", "12390013", "111",
				"thin:@172.20.2.218:1541:HMUAT", "appsro"));// "thin:@172.20.24.52:1521:HTWDEV","apps"));

	}

}
