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
