import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCTest {
	public static void insert() {
		
		//DB와 연결
		java.sql.Connection con = null;
		//SQL송신
		java.sql.Statement stmt = null;
		String insertSQL =
				"INSERT INTO customer(id, pwd, name) VALUES ('id8', 'p8', 'n8')"; 

		String url = "jdbc:oracle:thin:@localhost:1521:xe"; //JDBC프로토콜 url구조는 DB사마다 다름
		String user = "scott";
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와 연결 성공");

			stmt = con.createStatement();
			//con.createStatement(); 주의!
			int rowcnt = stmt.executeUpdate(insertSQL);
			System.out.println("SQL구문 송신 성공:처리건수=" + rowcnt);			
		} catch (SQLException e) {
			e.printStackTrace();
			return;
		} finally {
			System.out.println("DB와 연결 해제");
			if(stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public static void selectAll() {
		Connection con = null; //DB연결
		Statement stmt = null; //SQL구문송신
		ResultSet rs = null; //SELECTSQL구문의 수신
		String selectSQL = "SELECT id, pwd, name, zipcode, addr1\r\n" + 
				"FROM customer";
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "scott";
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs = stmt.executeQuery(selectSQL);
			//System.out.println(rs);
			while(rs.next()) { //while(rs.next()==true){
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String zipcode = rs.getString(4);
				String addr1 = rs.getString(5);
				System.out.println(id + ":" + pwd + ":" + name + ":" + zipcode + ":" + addr1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return;
		} finally {
			System.out.println("DB와의 연결해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public static void selectById() {
		Connection con = null; //DB연결
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SQL결과 수신
		
		String keyboardId = "id3"; //키보드로 입력된 아이디값
		String selectByIdSQL = "SELECT *\r\n" + 
				"FROM customer\r\n" + 
				"WHERE id = '" + keyboardId +"'";
		//id1고객의 비번, 이름, 우편번호, 상세주소 출력하시오
		
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "scott";
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs = stmt.executeQuery(selectByIdSQL);
			if(rs.next()) { //if(rs.next() == true){
				//ID에 해당고객이 있는경우
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String zipcode = rs.getString(4);
				String addr1 = rs.getString(5);
				System.out.println(id + ":" + pwd + ":" + name + ":" + zipcode + ":" + addr1);
			}else {
				//ID에 해당고객이 없는 경우
				System.out.println("ID에 해당고객이 없습니다");
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			System.out.println("DB와의 연결해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	public static void selectByIdPstmt() {
		Connection con = null;
		PreparedStatement pstmt = null; //Statement의 하위인터페이스
		ResultSet rs = null;
		String keyboardId = "id3";
		String selectByIdSQL = 
				"SELECT * FROM customer WHERE id=?";//바인드변수위치는 값위치만 가능
		        //"UPDATE customer SET name=? WHERE id=?"; //OK
		        //"SELECT * FROM ? WHERE ?=? ORDER BY name ?"; //ERROR
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "scott";
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			pstmt = con.prepareStatement(selectByIdSQL);
			pstmt.setString(1, keyboardId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString(3);
				System.out.println(id+":" + pwd + ":" + name);				
			}else {
				System.out.println("고객없음!");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		
	}
	public static void main(String[] args) {
		//JDBC드라이버 로드
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("JDBC드라이버 로드 성공");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return;
		}
		//insert();
		//selectAll();
		//selectById();
		//selectByIdPstmt()
		
		
		Connection con = null;
		try {
		//JDBC드라이버로드와 DB연결담당하는 메서드완성하시오
			con = com.my.sql.MyConnection.getConnection();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		com.my.sql.MyConnection.close(con); //연결해제를 담당하는 메서드 완성하시오
			
			
		
		
		
		
		
		

	}

}
