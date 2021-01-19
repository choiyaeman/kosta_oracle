# day09

자바 언어 기반으로 DB에 접속해서 추가, 수정, 삭제, 조회

![1](https://user-images.githubusercontent.com/63957819/105046456-78a6bc80-5aac-11eb-907f-6817c840dd84.png)

오라클은 1521번 포트를 열고 클라이언트 접속을 기다리고 있다

소켓을 만들고 접속을 하고 데이터를 보내려면 스트림 처리 해야 하는데 jvm 자바 개발자들이

데이터를 주고 받고 일련의 작업을 쉽게 할 수 있도록 오라클에서 제공을 해준다. 자바 개발자를 위한 JDBC 드라이버(압축파일)이라 한다.  

제일 먼저 첫 번째 JDBC드라이버를 JVM에 설치를 해야 한다. 프로그램이 정상 실행이 될 수 있도록 압축 파일을 java명령어에 연결만 시켜주면 된다. java명령어 연결해서 쓰는 방법은 java -cp bin A → A.class파일을 bin디렉토리에서 찾아라 그리고 실행해라! 의미이다. 압축 파일이 -cp옵션에 연결되어 있으면 된다. 예를들어 오라클에서 제공되는 드라이버 압축 파일이 이름이 ojdbc6.jar라 하면 가져와서 jvm개발자의 디렉토리에 가져와서 java -cp c:\ojdbc6.jar;bin A → A클래스르 실행할 때 bin디렉토리에서만 찾는게 아니라 c드라이브에 ojdbc6자료를 압축 파일에서 찾아라. 먼저 ojdbc6자료를 찾고 없으면 bin 디렉토리에서 찾아라. 연결의 의미가 -cp이고 두 번째 할 일이db에 연결하는 절차이다. 세 번째 SQL문장을 DB로 송신. 네 번째 결과를 수신하고 다섯 번째 결과 사용 마지막으로 여섯 번째 db연결 해제이다.

![2](https://user-images.githubusercontent.com/63957819/105046460-7a708000-5aac-11eb-9e3c-2cc3bb7103e6.png)

C:\oraclexe\app\oracle\product\11.2.0\server\jdbc\lib

Ojdbc6.jar에서 6는 Java6[jdk1.6]을 의미한다.

![3](https://user-images.githubusercontent.com/63957819/105046462-7a708000-5aac-11eb-8cf4-2866730fb0e1.png)

새로 LIB파일을 만들고 LIB경로에 갖다 놓는다.

- [JDBCTest.java](http://jdbctest.java) -insert

```java

import java.sql.DriverManager;
import java.sql.SQLException;

public class JDBCTest {
	
	public static void main(String[] args) {
		//JDBC드라이버 로드
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("JDBC드라이버 로드 성공");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return;
		} 
		//DB와 연결
		java.sql.Connection con = null;
		//SQL송신
		java.sql.Statement stmt = null;
		String insertSQL = "INSERT INTO customer(id, pwd, name) VALUES ('id8', 'p8', 'n8')";
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; //JDBC프로토콜 url구조는 DB사마다 다름. 
		String user = "scott"; //접속할 계정명
		String password = "tiger"; //scott계정에 접속할 비번
		try {
			con = DriverManager.getConnection(url, user, password); 
			System.out.println("DB와 연결 성공");
			
			stmt = con.createStatement(); //송신용 객체 반환. stmt를 송신용 output스트림이라 보면 된다. con이 소켓과 같은 역할
			int rowcnt = stmt.executeUpdate(insertSQL); //성공 처리된 건수 //stmt.executeUpdate(insertSQL); insert한 내용이 db서버로 전달된다.
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

}
```

forName은 주어진 문자열 이름에 해당하는 클래스나 인터페이스와 연관되어 있는 클래스 객체를 리턴한다.

![4](https://user-images.githubusercontent.com/63957819/105046465-7b091680-5aac-11eb-837d-21f6c493eef9.png)

java -cp c:\LIB\ojdbc6.jar;bin 추가해서 실행시켜줘야 오라클 전용jdbc를 로드 할 수 있다.

![5](https://user-images.githubusercontent.com/63957819/105046467-7b091680-5aac-11eb-8936-c19522b9acef.png)

jdbc 오른쪽 클릭> build path >configure build path

Libraries > Add External JARs > ojdbc6 선택> apply

![6](https://user-images.githubusercontent.com/63957819/105046469-7ba1ad00-5aac-11eb-9a4d-1a73df2dfccc.png)

static변수는 클래스가 로드 되자마자 자동 초기화 된다.

String url = "jdbc:oracle:thin:@localhost:1521:xe"; → jdbc: 다음에 db회사이름 : 다음은 db사마다 다 다름

![7](https://user-images.githubusercontent.com/63957819/105046473-7c3a4380-5aac-11eb-893b-3866c88dcbb1.png)

db설계하고 샘플 데이터 넣을 때도 실전처럼 넣어야 한다. 그리고 화면 별로 필요한 SQL구문이 먼저 도출 되어야 한다. 

- [JDBCTest.java](http://jdbctest.java) -selectAll

```java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCTest {
	public static void insert() {

		// DB와 연결
		java.sql.Connection con = null;
		// SQL송신
		java.sql.Statement stmt = null;
		String insertSQL = "INSERT INTO customer(id, pwd, name) VALUES ('id8', 'p8', 'n8')";
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; // JDBC프로토콜 url구조는 DB사마다 다름.
		String user = "scott"; // 접속할 계정명
		String password = "tiger"; // scott계정에 접속할 비번
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와 연결 성공");

			stmt = con.createStatement(); // 송신용 객체 반환. stmt를 송신용 output스트림이라 보면 된다. con이 소켓과 같은 역할
			int rowcnt = stmt.executeUpdate(insertSQL); // 성공 처리된 건수 //stmt.executeUpdate(insertSQL); insert한 내용이 db서버로 전달된다.
			System.out.println("SQL구문 송신 성공:처리건수=" + rowcnt);

		} catch (SQLException e) {
			e.printStackTrace();
			return;
		} finally {
			System.out.println("DB와 연결 해제");
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static void main(String[] args) {
		// JDBC드라이버 로드
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("JDBC드라이버 로드 성공");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return;
		}
		//insert();
		
		Connection con = null; //DB연결
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SELECTSQL구문의 수신
		String selectSQL = "SELECT id, pwd, name, zipcode, addr1\r\n" + 
				"FROM customer"; //\r\n 특수문자는 줄바꿈이라는 문법이다.
		
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger"; 
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs = stmt.executeQuery(selectSQL);
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
			System.out.println("DB와의 연결 해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		
	}

}
```

![8](https://user-images.githubusercontent.com/63957819/105046474-7c3a4380-5aac-11eb-8bc2-d7e4d81a6553.png)

sqldeveloper에서 테스트한 구문에서 ;는 빼고 복사해서 eclipase에 JDBCTest.java에 붙여 넣기 해야 한다.

![9](https://user-images.githubusercontent.com/63957819/105046477-7cd2da00-5aac-11eb-95fc-ed070a4e9c01.png)

이 결과가 resultset이다. rs가 참조하는 값이다. 다음행~다음 행으로 커서를 이동 시키는 메서드는 rs.next()이다. 첫 번째에서 두 번째 행 true..이렇게 rs.next메서드 호출하다가 끝을 만나 더 이상 행이 없다면 rs.next()의 결과가 false를 반환한다. 반복문 처리 하자. 

컬럼 값을 가져오는 메소드는 rs.get~~이다. ~~는 자료형에 따라서 호출되는 메서드를 달리 써줘야 한다. oracle자료형에는 숫자 형, 문자 형, 날짜 형 자료형이 있다. number, varchar2, char, date 타입들이 있고 자바 자료형 같은 경우 int, float, double, String, java.sql.Date이 있다. 호환 시켜줄 수 있는 메소드가 getter메서드이다. 

varchar2타입을 string형식을 얻어와야 하니깐 String s = rs.getString("id"); 해주면 된다.

컬럼명을 써도 좋고 인덱스를 써도 된다. 첫 번째 인덱스에 해당하는 컬럼 값을 가져온다면rs.getString(1); 여기서 주의할 점은 jdbc영역 만큼은 index가 1부터 시작한다!

![10](https://user-images.githubusercontent.com/63957819/105046479-7d6b7080-5aac-11eb-898f-27d5b83dca5d.png)

별칭을 쓰면 heading이 바뀐다. 별칭을 준다는 의도는 이제부터 너의 이름은 별칭으로 쓸거야라는 의미이다. 별칭을 사용했으면 반드시 별칭을 사용해야 한다.

원래 컬럼 위치는 세 번째인데 name은 실제 projection해온 자료는 두 번째이다. 이때는 프로젝션 해온 결과 위치이므로 2이다.

![11](https://user-images.githubusercontent.com/63957819/105046481-7d6b7080-5aac-11eb-88f6-61b3346eb30d.png)

이때 id값을 가져오려 했을 때 c.id라 해야될가 아님 id라 해야될가? 실행 했을 때 Heading에 질의 결과가 c.id 아님 id라 찍힐까? 그냥 id가 찍힌다. 그러므로 같아야 하므로 id라고 해야 한다.

실행 결과>

![12](https://user-images.githubusercontent.com/63957819/105046482-7e040700-5aac-11eb-964c-fbb9f54e8587.png)

db하고의 연결은 db쪽에 세션을 만드는 거다. 연결하고 짧게 끊어지는 게 안전한 거다.

- [JDBCTest.java](http://jdbctest.java) -selectById

```java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCTest {
	public static void insert() {

		// DB와 연결
		java.sql.Connection con = null;
		// SQL송신
		java.sql.Statement stmt = null;
		String insertSQL = "INSERT INTO customer(id, pwd, name) VALUES ('id8', 'p8', 'n8')";
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; // JDBC프로토콜 url구조는 DB사마다 다름.
		String user = "scott"; // 접속할 계정명
		String password = "tiger"; // scott계정에 접속할 비번
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와 연결 성공");

			stmt = con.createStatement(); // 송신용 객체 반환. stmt를 송신용 output스트림이라 보면 된다. con이 소켓과 같은 역할
			int rowcnt = stmt.executeUpdate(insertSQL); // 성공 처리된 건수 //stmt.executeUpdate(insertSQL); insert한 내용이 db서버로 전달된다.
			System.out.println("SQL구문 송신 성공:처리건수=" + rowcnt);

		} catch (SQLException e) {
			e.printStackTrace();
			return;
		} finally {
			System.out.println("DB와 연결 해제");
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (con != null) {
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
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SELECTSQL구문의 수신
		String selectSQL = "SELECT id, pwd, name, zipcode, addr1\r\n" + 
				"FROM customer"; //\r\n 특수문자는 줄바꿈이라는 문법이다.
		
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger"; 
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs = stmt.executeQuery(selectSQL);
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
			System.out.println("DB와의 연결 해제");
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
		// JDBC드라이버 로드
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("JDBC드라이버 로드 성공");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return;
		}
		//insert();
		//selectAll();
		Connection con = null; //DB연결
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SQL결과 수신
		
		String keyboardId = "id1"; //키보드로 입력된 아이디값
		String selectByIdSQL = "SELECT *\r\n" + 
				"FROM customer\r\n" + 
				"WHERE id = '" + keyboardId +"'"; //아이디에 해당하는 고객을 찾기
		//id1고객의 비번, 이름, 우편번호, 상세주소 출력하시오.
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs= stmt.executeQuery(selectByIdSQL); //select구문 처리하려면 executeQuery
			if(rs.next()) { //if(rs.next() == true) {  //id 컬럼은 pk이므로 자료는 한 행 밖에없다
				//ID에 해당 고객이 있을 경우
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String zipcode = rs.getString(4);
				String addr1 = rs.getString(5);
				System.out.println(id + ":" + pwd + ":" + name + ":" + zipcode + ":" + addr1);
			} else {
				//ID에 해당고객이 없을 경우
				System.out.println("ID에 해당 고객이 없습니다.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			System.out.println("DB와의 연결 해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
			
	}

}
```

![13](https://user-images.githubusercontent.com/63957819/105046484-7e040700-5aac-11eb-85ef-28e24026f33b.png)

먼저 SQL구문을 테스트 해보자 테스트가 끝나면 해당하는 자바 프로그램을 접속해서 붙여 넣자

실행 결과 >

![14](https://user-images.githubusercontent.com/63957819/105046487-7e9c9d80-5aac-11eb-9747-0017128da369.png)

 

- [JDBCTest.java](http://jdbctest.java) -selectByIdPstmt

```java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCTest {
	public static void insert() {

		// DB와 연결
		java.sql.Connection con = null;
		// SQL송신
		java.sql.Statement stmt = null;
		String insertSQL = "INSERT INTO customer(id, pwd, name) VALUES ('id8', 'p8', 'n8')";
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; // JDBC프로토콜 url구조는 DB사마다 다름.
		String user = "scott"; // 접속할 계정명
		String password = "tiger"; // scott계정에 접속할 비번
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와 연결 성공");

			stmt = con.createStatement(); // 송신용 객체 반환. stmt를 송신용 output스트림이라 보면 된다. con이 소켓과 같은 역할
			int rowcnt = stmt.executeUpdate(insertSQL); // 성공 처리된 건수 //stmt.executeUpdate(insertSQL); insert한 내용이 db서버로 전달된다.
			System.out.println("SQL구문 송신 성공:처리건수=" + rowcnt);

		} catch (SQLException e) {
			e.printStackTrace();
			return;
		} finally {
			System.out.println("DB와 연결 해제");
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (con != null) {
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
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SELECTSQL구문의 수신
		String selectSQL = "SELECT id, pwd, name, zipcode, addr1\r\n" + 
				"FROM customer"; //\r\n 특수문자는 줄바꿈이라는 문법이다.
		
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger"; 
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs = stmt.executeQuery(selectSQL);
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
			System.out.println("DB와의 연결 해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	public static void selectByID() {
		Connection con = null; //DB연결
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SQL결과 수신
		
		String keyboardId = "id1"; //키보드로 입력된 아이디값
		String selectByIdSQL = "SELECT *\r\n" + 
				"FROM customer\r\n" + 
				"WHERE id = '" + keyboardId +"'"; //아이디에 해당하는 고객을 찾기
		//id1고객의 비번, 이름, 우편번호, 상세주소 출력하시오.
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs= stmt.executeQuery(selectByIdSQL); //select구문 처리하려면 executeQuery
			if(rs.next()) { //if(rs.next() == true) {  //id 컬럼은 pk이므로 자료는 한 행 밖에없다
				//ID에 해당 고객이 있을 경우
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String zipcode = rs.getString(4);
				String addr1 = rs.getString(5);
				System.out.println(id + ":" + pwd + ":" + name + ":" + zipcode + ":" + addr1);
			} else {
				//ID에 해당고객이 없을 경우
				System.out.println("ID에 해당 고객이 없습니다.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			System.out.println("DB와의 연결 해제");
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
		// JDBC드라이버 로드
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
		
		Connection con = null;
		PreparedStatement pstmt = null; //Statement의 하위 인터페이스
		ResultSet rs = null;
		String keyboardId = "id3";
		String selectByIdSQL = 
				"SELECT * FROM customer WHERE id=?"; //?는 바인드 변수를 의미. 바인드 변수가 올 수 있는 위치는  값 위치만 가능.
				//"UPDATE customer SET name=? WHERE id=?"; //OK
				//"SELECT * FROM ? WHERE ?=?; ORDER BY name?"//Error
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			pstmt = con.prepareStatement(selectByIdSQL);
			pstmt.setString(1, keyboardId); //첫 번째 물음표에 얼마의 값을 대입하냐의 바인드값 설정 작업.
			pstmt.executeQuery();
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				System.out.println(id + ":" + pwd + ":" + name);
			} else {
				System.out.println("고객 없음!");
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
			if(con != null) { //con은 db하고 연결되는 소켓역할
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			 }
		}
		
	}

}
```

![15](https://user-images.githubusercontent.com/63957819/105046489-7e9c9d80-5aac-11eb-8682-eaff8ca0dcf5.png)

왼쪽 코드는 statement 오른쪽 코드는 preparedStatement 사용한 거다. 

차이점은 statement는 sql구문에서 직접 작은 따옴표를 열고 다는 불편한 작업을 한다.

preparedStatement는 바인드를 쓰고 인자 값으로 sql 구문이 미리 들어가야 한다. 첫 번째 물음표에 대한 값을 설정을 한다. executQuery메서드로 인자 값이 없다.

![16](https://user-images.githubusercontent.com/63957819/105046490-7f353400-5aac-11eb-9de6-9f91b9c3cdbc.png)

preparedStatement 쓰게 되면 미리 db서버에 송신을 한번하고 즉 중복되는 구문이 미리 db에가서 기억 되는 거다. 그리고 ?에 해당하는 값만 변경

실행결과>

![17](https://user-images.githubusercontent.com/63957819/105046493-7fcdca80-5aac-11eb-91cc-6fcdde5147ff.png)

---

- JDBCTest.java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCTest {
	public static void insert() {

		// DB와 연결
		java.sql.Connection con = null;
		// SQL송신
		java.sql.Statement stmt = null;
		String insertSQL = "INSERT INTO customer(id, pwd, name) VALUES ('id8', 'p8', 'n8')";
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; // JDBC프로토콜 url구조는 DB사마다 다름.
		String user = "scott"; // 접속할 계정명
		String password = "tiger"; // scott계정에 접속할 비번
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와 연결 성공");

			stmt = con.createStatement(); // 송신용 객체 반환. stmt를 송신용 output스트림이라 보면 된다. con이 소켓과 같은 역할
			int rowcnt = stmt.executeUpdate(insertSQL); // 성공 처리된 건수 //stmt.executeUpdate(insertSQL); insert한 내용이 db서버로 전달된다.
			System.out.println("SQL구문 송신 성공:처리건수=" + rowcnt);

		} catch (SQLException e) {
			e.printStackTrace();
			return;
		} finally {
			System.out.println("DB와 연결 해제");
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (con != null) {
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
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SELECTSQL구문의 수신
		String selectSQL = "SELECT id, pwd, name, zipcode, addr1\r\n" + 
				"FROM customer"; //\r\n 특수문자는 줄바꿈이라는 문법이다.
		
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger"; 
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs = stmt.executeQuery(selectSQL);
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
			System.out.println("DB와의 연결 해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	public static void selectByID() {
		Connection con = null; //DB연결
		Statement stmt = null; //SQL구문 송신
		ResultSet rs = null; //SQL결과 수신
		
		String keyboardId = "id1"; //키보드로 입력된 아이디값
		String selectByIdSQL = "SELECT *\r\n" + 
				"FROM customer\r\n" + 
				"WHERE id = '" + keyboardId +"'"; //아이디에 해당하는 고객을 찾기
		//id1고객의 비번, 이름, 우편번호, 상세주소 출력하시오.
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			System.out.println("DB와의 연결 성공");
			stmt = con.createStatement();
			rs= stmt.executeQuery(selectByIdSQL); //select구문 처리하려면 executeQuery
			if(rs.next()) { //if(rs.next() == true) {  //id 컬럼은 pk이므로 자료는 한 행 밖에없다
				//ID에 해당 고객이 있을 경우
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String zipcode = rs.getString(4);
				String addr1 = rs.getString(5);
				System.out.println(id + ":" + pwd + ":" + name + ":" + zipcode + ":" + addr1);
			} else {
				//ID에 해당고객이 없을 경우
				System.out.println("ID에 해당 고객이 없습니다.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			System.out.println("DB와의 연결 해제");
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	public static void selectByIDPstmt() {
		Connection con = null;
		PreparedStatement pstmt = null; //Statement의 하위 인터페이스
		ResultSet rs = null;
		String keyboardId = "id3";
		String selectByIdSQL = 
				"SELECT * FROM customer WHERE id=?"; //?는 바인드 변수를 의미. 바인드 변수가 올 수 있는 위치는  값 위치만 가능.
				//"UPDATE customer SET name=? WHERE id=?"; //OK
				//"SELECT * FROM ? WHERE ?=?; ORDER BY name?"//Error
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger";
		try {
			con = DriverManager.getConnection(url, user, password);
			pstmt = con.prepareStatement(selectByIdSQL);
			pstmt.setString(1, keyboardId); //첫 번째 물음표에 얼마의 값을 대입하냐의 바인드값 설정 작업.
			pstmt.executeQuery();
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				System.out.println(id + ":" + pwd + ":" + name);
			} else {
				System.out.println("고객 없음!");
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
			if(con != null) { //con은 db하고 연결되는 소켓역할
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			 }
		}
	}
	public static void main(String[] args) {
		// JDBC드라이버 로드
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
		//JDBC드라이버 로드와 DB연결 담당하는 메서드 완성하시오
		con = com.my.sql.MyConnection.getConnection(); 
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		com.my.sql.MyConnection.close(con); //연결해제를 담당하는 메서드 완성 하시오
		
	}

}
```

- MyConnection.java

```java
package com.my.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MyConnection {
	public static Connection getConnection() throws Exception { // 예외를 떠 넘겨주자 ClassNotFoundException, SqlException 부모로 Exception 해주면 된다.
		Class.forName("oracle.jdbc.driver.OracleDriver");
		System.out.println("JDBC드라이버 로드 성공");
		
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String user = "scott"; 
		String password = "tiger";
		Connection con = DriverManager.getConnection(url, user, password);
		return con;
	}
	
	public static void close(Connection con) { //close할때 발생하는 예외는 무시해도된다 그래서 메서드 내에서 try~catch 해주자
		if(con != null) { 
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		 }
	}
}
```

db연결에 관련된 메서드, 해제 메서드를 갖고 있는 클래스를 만들자

![18](https://user-images.githubusercontent.com/63957819/105046494-80666100-5aac-11eb-93b3-7eede34b24de.png)
