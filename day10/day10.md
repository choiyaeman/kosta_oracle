# day10

- jdbc1.java

```java
package com.my.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class MyConnection {
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		System.out.println("JDBC드라이버 로드 성공");
	}
	
	public static Connection getConnection() throws Exception {
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "scott";
		String password = "tiger";
		Connection con = DriverManager.getConnection(url, user, password);
		return con;
	}
	
	public static void close(Connection con, Statement stmt, ResultSet rs) {
		if(rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}			
		}
		close(con, stmt);
	}
	
	public static void close(Connection con, Statement stmt) {
		if(stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		close(con);
	}
	public static void close(Connection con) {
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

오라클 접속 어플리케이션을 개발하려면 드라이버(ojdbcXX.jar)를 사용할 수 있도록 빌드패스 설정

![day10%209798e2186d7a4670b4b04685f8754686/Untitled.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled.png)

새로운 jdbc1프로젝트 만들고 어제 했던 MyConnection 복사 붙여넣자!

con이라는 놈은 오라클데이터베이스와의 연결을 담당하는 소켓이라 보면 된다. 그 con연결되어있는 Statement 또는 PreparedStatement가 outputstream의 역할을 해준다고 보면 된다. 

각각 다 close할 때 순서가 statement부터 close하고 connection을 close한다. 

오버로드해서 statement, preparedstatemnet도 close하게 할 거다. 

statement가 부모의 역할을 하고 preparedstatement가 자식의 역할을 한다. 부모타입으로 충분히 upcasting할 수 있다.

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%201.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%201.png)

Myconnection.close(con, stmt); 사용하게 하려면 Statement stmt=con.~~; 되고 있어야 하고 stmt인자를 전달해줘야 한다.

Myconnectinon.close(con, pstmt); 자식 타입의 객체가 사용이 되다가 메서드의 인자로 쓰였다. 인자로 쓰일 때까지 자식타입으로 쓰이다가 메소드가 호출되면 pstmt의 인자가 매개변수(Statement) 부모 타입으로 Upcasting이 된다.

jdbc드라이버 로드는 프로그램 실행 시에 한번만 로드되면 된다. 

메소드 사용할 때 클래스 이름. → MyConnection.getConnection(~) 모두 static메서드로 쓰였다.

getConnetion을 사용해야 하는데 static메서드들 보다 먼저 초기화가 되려면 생성자는 의미가 없다. 클래스명. 은 생성자가 아무 의미가 없다 new MyConnection(); 생성될 때 사용되는거므로 

적절한 위치는 static블록이다. static초기화 블럭이라 한다.

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%202.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%202.png)

하위 클래스(CustomerDAOOracle)에서도 구현해줘야 한다.

메인뷰는 키보드로부터 값을 입력 받는 역할을 한다. 예를 들어 1번 선택 시 1번에 해당하는 일 처리를 하러 Controller가 제어하게 되어있다. 1번이 선택 되었을 경우 예를 들어 가입이라 하면 가입에 관련된 컨트롤용 메서드가 호출이 되고 실제 일 처리는 서비스에게 맡긴다. 서비스가 가입용 일 처리를 진행하게 된다. 서비스 단에서 필요한 dao메서드들을 여러 개 호출할 수 있다. 가입하려는 사람의 인증 절차를 진행하고 인증에 대한 절차가 완료가 되면 완료가 된 상태에서만 dao메서드를 호출하고 안되면 내치는 거다. dao는 DB하고 일만 하는 거다. DB하고 일을 하기 전에 하는 모든 절차를 하는 게 Service인 거다. 성공할 경우 결과 값을 Controller에게 보내줄 거다. Controller가 성공 시에는 Success View, 실패 시에 FailView라는 결과를 보여줄 view로 호출하는 거다. 가장 사용자와 만나는 쪽은 View단이다.  Controller에서는 실제 일 처리를 하는 게 아니고 Service에서 하는 거다.  View와 Controller는 웹으로 만들고 나머지는 웹, 일반어플 재사용이 되도록 할 거다.

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%203.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%203.png)

- CustomerDAOOracle.java

```java
package com.my.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.my.exception.AddException;
import com.my.exception.FindException;
import com.my.exception.ModifyException;
import com.my.exception.RemoveException;
import com.my.sql.MyConnection;
import com.my.vo.Customer;

public class CustomerDAOOracle implements CustomerDAO {

	@Override
	public void insert(Customer c) throws AddException {
		Connection con = null;
		try {
			con = MyConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
			throw new AddException("고객 추가 실패: 이유=" + e.getMessage());
		}
		PreparedStatement pstmt = null;
		String insertSQL = 
				"INSERT INTO customer(id, pwd, name, zipcode, addr1) VALUES (?,?,?,?,?)";
		try {
			pstmt = con.prepareStatement(insertSQL);
			pstmt.setString(1, c.getId());
			pstmt.setString(2, c.getPwd());
			pstmt.setString(3, c.getName());
			pstmt.setString(4, "12345");
			pstmt.setString(5, "6층");
			pstmt.executeUpdate();
		} catch (SQLException e) {
			//e.printStackTrace(); 고객들에게 배포를 할때는 왠만하면 안쓰는게 좋다
			if(e.getErrorCode() == 1) { //PK중복
				throw new AddException("이미 존재하는 아이디입니다");
			} else {
				e.printStackTrace(); // 그 외의 경우
			}
		} finally {
			MyConnection.close(con, pstmt);
		}
	}
	
	@Override
	public List<Customer> selectAll() throws FindException {
		Connection con = null; //db와의 역할하는 소켓
		PreparedStatement pstmt = null; //출력 스트림
		ResultSet rs = null; //입력 스트림
		try {
			con = MyConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
			throw new FindException(e.getMessage());
		}
		//String selectSQL = "SELECT * FROM customer WHERE id>='id999' ORDER BY id"; //고객이 한명도 없었을때
		String selectSQL = "SELECT * FROM customer ORDER BY id";
		try { //try블록에서 예외가 발생하면 그 즉시 catch로가서 처리하고 finally로 간다. return을 만나게하거나 예외를 throw해줘야 한다.
			pstmt = con.prepareStatement(selectSQL);
			rs = pstmt.executeQuery(); //select구문 처리시 사용되는 메서드
			List<Customer> list = new ArrayList<>();
			while(rs.next()) {
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String zipcode = "12345";
				String addr1 = "6층";
				Customer c = new Customer(id, pwd, name);
				list.add(c);
			}
			if(list.size() == 0) {
				throw new FindException("고객이 한명도 없습니다");
			}
			return list; //return하기 바로 직전에 finally 구문을 수행하고 return이 된다. 
		} catch (SQLException e) {
			e.printStackTrace();
			throw new FindException(e.getMessage()); // try블록에서 예외 발생시 예외를 강제로 떠 넘긴다. // throw하기 직전에 finally수행하고 throw되는거다.
		} finally {
			MyConnection.close(con, pstmt, rs);
		}
	}

	@Override
	public Customer selectById(String id) throws FindException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = MyConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
			throw new FindException(e.getMessage());
		}
		String selectByIdSQL = "SELECT * FROM customer WHERE id=?";
		try { //sqlexception이 발생할수있으니까
		pstmt = con.prepareStatement(selectByIdSQL);
		pstmt.setString(1, id);
		rs = pstmt.executeQuery();
		if(rs.next()) {
			String pwd = rs.getString("pwd");
			String name = rs.getString("name");
			String zipcode = "12345";
			String addr1 = "6층";
			return new Customer(id, pwd, name);
		} else {
			throw new FindException("아이디에 해당 고객이 없습니다");
		}
	} catch(SQLException e) {
		throw new FindException(e.getMessage()); //다양하게 처리하기위해 getMessage
	} finally {
			MyConnection.close(con, pstmt, rs);
	}
}
	@Override
	public Customer update(Customer c) throws ModifyException {
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = MyConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
			throw new ModifyException(e.getMessage());
		}
		//비번,이름 모두 수정 UPDATE customer SET pwd=?, name=? WHERE id=?
		//비번 수정 		 UPDATE customer SET pwd=?, WHERE id=?
		//이름 수정		 UPDATE customer SET name=? WHERE id=?
//		String updateSQL = "UPDATE customer SET pwd=?, name=? WHERE id=?"; //고객의 비번만 아니면 이름만 바꾸는 경우는? 이 sql구문은 적절치 않다. sql구문은 preparedStatement 효과에 적절치 않다
//		try {
//			pstmt = con.prepareStatement(updateSQL);
//			pstmt.setString(1, c.getPwd()); //?위치 1부터. db의 규칙을 그대로 따라 1부터 시작해야한다.
//			pstmt.setString(2, c.getName());
//			pstmt.setString(3, c.getId());
//			pstmt.executeUpdate(); //dml,ddl 처리해주는 메소드
//		} catch(SQLException e) {
//			throw new ModifyException(e.getMessage());
//		} finally {
//			MyConnection.close(con, pstmt);
//		}
		
		Statement stmt = null;
		String updateSQL = "UPDATE customer SET "; //비번이름모두 수정, 비번 수정, 이름 수정 하는 공통적으로 쓰일 경우
		String updateSQLSet = "";
		String updateSQL1 = "WHERE id='" + c.getId() + "'";
		try {
			stmt = con.createStatement();
			boolean flag = false; //수정여부
			if(c.getPwd() != null && !c.getPwd().equals("")) { //비번 수정 null도아니고 빈 문자열도 아닌경우
				updateSQLSet = "pwd='" + c.getPwd() + "' ";
				flag = true;
			}
			if(c.getName() != null && !c.getName().equals("")) { //이름 수정 null도아니고 빈 문자열도 아닌경우
				if(flag) { //flag가 true인 경우 이름을 수정하는 경우에서 비번을 이미 수정하겠다라는 case. 이름 수정하러 왔을 때 이름을 수정하는 입장에서 비번도 같이 수정하겠다라는 의미
					updateSQLSet += ",";
				}
				updateSQLSet += "name='" + c.getName() + "' ";
				flag = true;
			}
			
			if(flag) { //flag값이 true인 경우 
				System.out.println(updateSQL + updateSQLSet + updateSQL1); //먼저 테스트 해봐야한다.
				stmt.executeUpdate(updateSQL + updateSQLSet + updateSQL1); 
				try {
					return selectById(c.getId()); //변경 될 객체를 반환해야한다. 수정된 내용이 잘 들어가있는지 확인해야한다.
				} catch (FindException e) {
					e.printStackTrace();
					throw new ModifyException(e.getMessage());
				} 
			} else { //비번수정, 비번 이름 수정하는 case에 들어오지 않는 경우
				throw new ModifyException("수정할 내용이 없습니다");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ModifyException(e.getMessage());
		} finally {
			MyConnection.close(con, stmt);
		}
	}

	@Override
	public Customer delete(String id) throws RemoveException {
		Customer c;
		try { //삭제할 고객찾기
			c = selectById(id); //먼저 고객정보 찾기
		} catch (FindException e) {
			//e.printStackTrace();
			throw new RemoveException(e.getMessage()); //id가없어서 삭제 못할때
		}
		// 조회했다가 삭제하려는 중간 사이에 누군가가 id고객을 삭제할 수 있다. 다시한번 처리건수를 비교해야한다
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = MyConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RemoveException(e.getMessage()); //삭제가 될때 발생하는 예외니깐 감싸는거라 생각하면 된다.
		}
		String deleteSQL = "DELETE FROM customer WHERE id=?";
		try {
			pstmt = con.prepareStatement(deleteSQL);
			pstmt.setString(1, id);
			int rowcnt = pstmt.executeUpdate(); //rowcnt는 처리건수
			if(rowcnt != 1) { //삭제건수가 0건
				throw new RemoveException("아이디에 해당 고객이 없습니다");
			}
			return c;
		} catch(SQLException e) {
			throw new RemoveException(e.getMessage());
		} finally {
			MyConnection.close(con, pstmt);
		}
	}
	public static void main(String[] args) {
		CustomerDAOOracle dao = new CustomerDAOOracle();
		//고객 삭제 테스트
		String id = "id11";
		try {
			Customer c = dao.delete(id);
			System.out.println("삭제 테스트 성공! 삭제된 고객정보:" + c);
		} catch (RemoveException e) {
			e.printStackTrace();
		}
		
		//고객정보수정 테스트
		/*Customer c = new Customer();
		c.setId("id1");
		//c.setPwd("updp"); c.setName("updn"); //1)비번이름 모두 수정 
		
		//c.setPwd("updp1"); //비번만 수정
		
		//c.setName("updn1"); //이름만 수정 
		
		try {
			dao.update(c);
		} catch (ModifyException e) {
			e.printStackTrace();
		}*/
		
		//고객 ID로 검색 테스트
		/*String id = "id999"; //"id999";
		try {
			Customer c = dao.selectById(id);
			System.out.println(c);
		} catch (FindException e) {
			e.printStackTrace();
		}*/
		
		//고객전체검색 테스트
		/*try {
			List<Customer> list = dao.selectAll();
			for(Customer c: list) {
				System.out.println(c); //c.toString()가 자동 호출됨
			}
		} catch (FindException e) {
			e.printStackTrace();
		}*/
		
		
		//고객추가 테스트
		/*Customer c = new Customer();
		//c.setId("id11"); c.setPwd("p11"); c.setName("n11");
		c.setId("id12"); //c.setPwd("p11"); c.setName("n11");
		c.setName("n12");
		try {
			dao.insert(c);
			System.out.println("추가 테스트 성공");
		} catch (AddException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage());
		}*/
	}

}
```

Customer클래스에 toString()가 오버라이딩 되어있어야 한다.

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%204.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%204.png)

메인메서드를 만들어서 insert메소드 호출하는 코드를 만들자

**insert 실행 결과>**

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%205.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%205.png)

추가 성공 시

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%206.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%206.png)

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%207.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%207.png)

PK중복 시 발생

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%208.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%208.png)

pwd값을 안줄 때 null 오류 뜬다. not null 제약 조건 위배!

**selectAll 실행 결과>**

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%209.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%209.png)

**selectByIDSQL 실행 결과>**

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2010.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2010.png)

id가 일치할 경우

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2011.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2011.png)

id에 해당하는 고객이 없는 경우

**update 실행 결과>**

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2012.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2012.png)

비번, 이름 모두 수정

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2013.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2013.png)

비번만 수정

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2014.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2014.png)

이름만 수정

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2015.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2015.png)

수정할 내용이 없을 경우

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2016.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2016.png)

sqldeveloper에서 아이디, 비번 변경된 것을 볼 수 있다.

**delete 실행 결과>**

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2017.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2017.png)

아이디에 대한 해당 고객이 있을 경우 삭제 성공

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2018.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2018.png)

아이디에 대한 해당 고객이 없을 경우 삭제 실패 해당 고객이x

uml 표기법 중에서 화살촉이 닫혔니 열렸니에 따라서 표기법이 달라진다. 닫히면 상속 구조이고 열리면 사용 구조 이다. 이런 것을 연관 관계라 부른다. 사용 관계라 보면 된다.

- CustomerService.java

```java
package com.my.service;

import java.util.List;

import com.my.dao.CustomerDAO;
import com.my.dao.CustomerDAOOracle;
import com.my.exception.AddException;
import com.my.exception.FindException;
import com.my.exception.ModifyException;
import com.my.exception.RemoveException;
import com.my.vo.Customer;

public class CustomerService {
	**private CustomerDAO dao = new CustomerDAOOracle();** //upcasting
	public List<Customer> findAll() throws FindException{
		List<Customer> cAll = dao.selectAll();//^	
		return cAll;
	}
	public void add(Customer c) throws AddException{
		dao.insert(c);//^
//		} catch (AddException e) {
//			System.out.println(e.getMessage());
//		}
	}
	public Customer findById(String id) throws FindException {
		 return dao.selectById(id);//^
	}
	public Customer modify(Customer c) throws ModifyException {
		// TODO Auto-generated method stub
		return dao.update(c);
	}
	public Customer remove(String id) throws RemoveException {
		return dao.delete(id);
	}
	public Customer login(String id, String pwd) throws FindException{
		try {
			Customer c = dao.selectById(id);//^
			if(c.getPwd().equals(pwd)) {//^				
				return c;
			}else {
	//			System.out.println("로그인 실패");
				throw new FindException("로그인  실패");
			}
		}catch(FindException e) {
	//		System.out.println("로그인 실패");
			throw new FindException("로그인  실패");
		}
	}
}
```

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2019.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2019.png)

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2020.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2020.png)

이런구조~

**CustomerMainView에서 실행 결과>**

사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:1

> 고객 전체 조회<<
JDBC드라이버 로드 성공
아이디는id1, 비밀번호는updp1, 이름은updn1입니다
아이디는id11, 비밀번호는u11, 이름은null입니다
아이디는id2, 비밀번호는p2, 이름은n2입니다
아이디는id3, 비밀번호는p3, 이름은n3입니다
아이디는id4, 비밀번호는p4, 이름은n4입니다
아이디는id5, 비밀번호는p5, 이름은n5입니다
아이디는id6, 비밀번호는p6, 이름은n6입니다
아이디는id7, 비밀번호는p7, 이름은n7입니다
아이디는id8, 비밀번호는p8, 이름은n8입니다
아이디는id9, 비밀번호는p9, 이름은n9입니다
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:66.로그인<<
아이디를 입력하세요:id11
비밀번호를 입력하세요:u11
로그인 성공
로그인된 고객정보:아이디는id11, 비밀번호는u11, 이름은null입니다작업구분:1-수정, 2-삭제, 9-로그아웃
1수정<<
비밀번호를 입력하세요.수정안하려면 enter누르세요:
u111
이름을 입력하세요.수정안하려면 enter누르세요:

UPDATE customer SET pwd='u111' WHERE id='id11'
수정 성공
수정된 고객정보:아이디는id11, 비밀번호는u111, 이름은null입니다
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:1

> 고객 전체 조회<<
아이디는id1, 비밀번호는updp1, 이름은updn1입니다
아이디는id11, 비밀번호는u111, 이름은null입니다
아이디는id2, 비밀번호는p2, 이름은n2입니다
아이디는id3, 비밀번호는p3, 이름은n3입니다
아이디는id4, 비밀번호는p4, 이름은n4입니다
아이디는id5, 비밀번호는p5, 이름은n5입니다
아이디는id6, 비밀번호는p6, 이름은n6입니다
아이디는id7, 비밀번호는p7, 이름은n7입니다
아이디는id8, 비밀번호는p8, 이름은n8입니다
아이디는id9, 비밀번호는p9, 이름은n9입니다
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:66.로그인<<
아이디를 입력하세요:id11
비밀번호를 입력하세요:u111
로그인 성공
로그인된 고객정보:아이디는id11, 비밀번호는u111, 이름은null입니다작업구분:1-수정, 2-삭제, 9-로그아웃
1수정<<
비밀번호를 입력하세요.수정안하려면 enter누르세요:

이름을 입력하세요.수정안하려면 enter누르세요:
n11
UPDATE customer SET name='n11' WHERE id='id11'
수정 성공
수정된 고객정보:아이디는id11, 비밀번호는u111, 이름은n11입니다
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:6

> 6.로그인<<
아이디를 입력하세요:id11
비밀번호를 입력하세요:n11
로그인  실패
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:66.로그인<<
아이디를 입력하세요:id11
비밀번호를 입력하세요:u111
로그인 성공
로그인된 고객정보:아이디는id11, 비밀번호는u111, 이름은n11입니다작업구분:1-수정, 2-삭제, 9-로그아웃
2삭제<<
삭제 성공
삭제된 고객정보:아이디는id11, 비밀번호는u111, 이름은n11입니다
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:1고객 전체 조회<<
아이디는id1, 비밀번호는updp1, 이름은updn1입니다
아이디는id2, 비밀번호는p2, 이름은n2입니다
아이디는id3, 비밀번호는p3, 이름은n3입니다
아이디는id4, 비밀번호는p4, 이름은n4입니다
아이디는id5, 비밀번호는p5, 이름은n5입니다
아이디는id6, 비밀번호는p6, 이름은n6입니다
아이디는id7, 비밀번호는p7, 이름은n7입니다
아이디는id8, 비밀번호는p8, 이름은n8입니다
아이디는id9, 비밀번호는p9, 이름은n9입니다
사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,6.로그인,  9.종료
작업을 선택하세요:9

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2021.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2021.png)

uml표기법에 메소드 부분에 밑줄이 그어져 있으면 static메서드이다. 

ER-Win 소프트가 무겁고 라이센스가 있고 현업에서 많이 쓰이는 소프트웨어에는 EA가 있다.

ER-Win을 쓰는거보다 대표 소프트웨어 중에 ExERD를 사용할 거다.

구글에 exerd 검색

[https://ko.exerd.com/](https://ko.exerd.com/) > download> Eclipse플러그인으로 설치 3버전 클릭

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2022.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2022.png)

[https://exerd.com/update/3.x/](https://exerd.com/update/3.x/) url복사

먼저, elicpse를 관리자 모드로 들어간다
	

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2023.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2023.png)

그리고 복사한 url을 복붙해서 eXERD체크 후 설치

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2024.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2024.png)

File> new> Other> General> Project> Finsih

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2025.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2025.png)

ERD 오른쪽 클릭> new> Other> eXERD에 eXERD File 선택> Finish

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2026.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2026.png)

DB에 있는 테이블을 다이어그램에 보여주는 것을 리버스 엔지니어링(역공학)이라 한다. (SCOTT.exerd, HR.exerd)

다이어그램을 그려서 테이블로 생성하는 것을 순공학이라 한다.

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2027.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2027.png)

exerd> exerd 환경 설정> exERD에 DBMS 연결 설정> Oracle 버전 선택 

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2028.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2028.png)

exerd> 리버스 엔지니어링

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2029.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2029.png)

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2030.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2030.png)

물리 이름을 논리 이름으로 사용 체크

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2031.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2031.png)

맨 오른쪽 아래 초록색 프로그래스바 클릭 후 모든 테이블 선택 후 Next

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2032.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2032.png)

왼쪽은 ERD를 보여줄 목록 오른쪽 테이블은 목록을 의미함

마찬가지로 HR.exerd도 만들어주자~

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2033.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2033.png)

 

![day10%209798e2186d7a4670b4b04685f8754686/Untitled%2034.png](day10%209798e2186d7a4670b4b04685f8754686/Untitled%2034.png)

점선으로 이어진 관계선은 비식별자 관계이다. employees하고 jobs테이블의 관계를 보자면 jobs라는 직무 정보가 먼저 추가되어 있어야 하고 employees의 사원 정보가 나중에 추가 되어야 한다.

먼저 추가되어야 하는 곳을 부모 엔터티 나중에 추가 되어야 하는 곳을 자식 엔터티라 한다. job_id pk를 일반 컬럼으로 fk로 참조 이것을 비식별자 관계라 하고 점선으로 표현한다.  job_history테이블은 경력 테이블을 의미한다. job_history테이블과 employees테이블 관계를 보면 사원이 부모 엔터티이고 경력 테이블이 자식 역할을 하는 거다. 부모의 pk를 자식의 pk로 참조 이것을 주 식별자 관계라 부른다. 주 식별자 관계는 실선으로 표현한다. 

세개로 이어진 것도 있고 하나로 이어진 경우도 있다. 이것을 참여자 수(카디넬리티)라 한다. 선이 하나로 이어져 있는 놈들을 참여자 수 중에서 One이라 한다. 여러 개 있는 것을 Many라 한다.

한 직무에 속한 사원은 여러 명이다. 맞닿아 있는 자식 쪽을 보면 Many이다.

한 사원이 담당하는 직무는 하나다. 맞닿아 있는 부모 쪽을 보면 One이다.

지역 테이블하고 부서 테이블 있는데 관계를 맺고 있다. 한 지역에 있는 부서는 여러 개 이다.

한 부서가 있는 지역은 하나이다. 부서와 지역의 관계를 보면 부서가 Many , 지역은 One 역할을 한다. Many to One 관계라 보면 된다.