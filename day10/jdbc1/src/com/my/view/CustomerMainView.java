package com.my.view;
import java.util.Scanner;

import com.my.control.CustomerController;
import com.my.share.CustomerShare;
import com.my.vo.Customer;

public class CustomerMainView {
	//private CustomerDAO dao = new CustomerDAOList(3);//^
	//Scanner타입의 sc멤버변수 선언
	private CustomerController controller = new CustomerController();
	private static Scanner sc = new Scanner(System.in);
	
	public void findAll() {
		System.out.println(">>1. 고객 전체 조회<<");
		controller.findAll();
	}
	
	public void add() {
		System.out.println(">>2. 고객추가<<");
		System.out.print("아이디를 입력하세요:");
		String id = sc.nextLine();
		System.out.print("비밀번호를 입력하세요:");
		String pwd = sc.nextLine();
		System.out.print("이름를 입력하세요:");
		String name = sc.nextLine();
		
//		try {
//			dao.insert(new Customer(id, pwd, name));//^
//		} catch (AddException e) {
//			System.out.println(e.getMessage());
//		}
		controller.add(new Customer(id, pwd, name));
	}
	public void findById() {
		System.out.println(">>3. 고객 ID로 조회<<");
		System.out.print("아이디를 입력하세요:");		
		String id = sc.nextLine();
//		Customer c4;
//		try {
//			c4 = dao.selectById(id);//^
//			System.out.println(c4.getId() + "," + c4.getPwd() + ", " + c4.getName());
//		} catch (FindException e) {
//			System.out.println(e.getMessage());//^
//		}		
		controller.findById(id);
	}	
	
//	public void modify() {
//		System.out.println(">>4. 고객 정보 수정<<");
//		System.out.print("아이디를 입력하세요:");
//		String id = sc.nextLine();
//		try {
//			dao.selectById(id);
//			modify(id);
//		}catch(FindException e) {
//			System.out.println(e.getMessage());
//		}
//	}
	
//	public void remove() {
//		System.out.println(">>5. 고객 정보 삭제<<");
//		System.out.print("아이디를 입력하세요:");
//		String id = sc.nextLine();
//		remove(id);
//	}
	//------로그인 후 수정,삭제인 경우 -----------
	/**
	 * 아이디에 해당하는 고객정보 수정
	 * @param id 아이디
	 */
	public void modify(String id) {
		System.out.println("비밀번호를 입력하세요.수정안하려면 enter누르세요:");
		String pwd = sc.nextLine(); //enter인 경우 ""이 됨
		System.out.println("이름을 입력하세요.수정안하려면 enter누르세요:");
		String name = sc.nextLine();
		
		Customer c = new Customer(id, pwd, name);
		controller.modify(c);
//		try {
//			Customer c1 = dao.update(c);
//			System.out.println("수정 성공!"+ c1.getId() + ", " + c1.getPwd() + ", " + c1.getName());
//		} catch (ModifyException e) {
//			System.out.println(e.getMessage());
//		}
	}
	/**
	 * 아이디에 해당하는 고객을 저장소에서 삭제
	 * @param id
	 */
	public void remove(String id) {
		controller.remove(id);
//		try {
//			dao.delete(id);
//			System.out.println("삭제성공");
//		} catch (RemoveException e) {
//			System.out.println(e.getMessage());
//		}
	}
	public void login() {
		System.out.println(">>6.로그인<<");
		System.out.print("아이디를 입력하세요:");
		String id = sc.nextLine();
		System.out.print("비밀번호를 입력하세요:");
		String pwd = sc.nextLine();
//		try {
//			Customer c = dao.selectById(id);//^
//			if(c.getPwd().equals(pwd)) {//^
//				System.out.println("로그인 성공");	
//				System.out.println("고객정보:아이디는" + c.getId()+
//				", 비밀번호는" + c.getPwd() + ", 이름은" + c.getName()+"입니다");
//				afterLogin(id);
//			}else {
//				System.out.println("로그인 실패");
//			}
//		}catch(FindException e) {
//			System.out.println("로그인 실패");
//		}		
		controller.login(id, pwd);
	}
	/**
	 * 로그인 성공된 후 메뉴
	 * @param id 로그인된 아이디값
	 */
	private void afterLogin(String id) {
		System.out.println(">>작업구분:1-수정, 2-삭제, 9-로그아웃");
		switch(sc.nextLine()) {
		case "1":
			System.out.println(">>수정<<");
			modify(id);
			break;
		case "2":
			System.out.println(">>삭제<<");
			remove(id);
			break;
		case "9":
			System.out.println(">>로그아웃<<");
			break;
		}
		logout();
	}
	public void logout() {
		controller.logout();
	}
	static public  void main(String[] args) {
		CustomerMainView customerMain = new CustomerMainView();
		while(true) {
			if(CustomerShare.loginedId == null) {
			System.out.print("사용법: 1.고객전체조회, 2.고객추가, 3.고객 ID로 조회,");// 4.고객수정, 5.고객삭제, 
			System.out.println("6.로그인,  9.종료");
			System.out.print("작업을 선택하세요:");
			String menu = sc.nextLine();
			//System.out.println(menu);
			if("1".equals(menu)) {
				customerMain.findAll();
			}else if("2".equals(menu)) {
				customerMain.add();
			}else if("3".equals(menu)) {
				customerMain.findById();
			}else if("6".equals(menu)) {
				customerMain.login();				
			}else if("9".equals(menu)) {				
				return;
			}
			}else {
				customerMain.afterLogin(CustomerShare.loginedId);
			}
		}
	}
}
