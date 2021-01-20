package com.my.view;
import com.my.vo.Customer;
public class CustomerSuccessView {
	
	public void findView(Customer c) {
		System.out.println("아이디는" + c.getId()+", 비밀번호는" + c.getPwd() + ", 이름은" + c.getName()+"입니다");
	}
	public void addView(Customer c) {
		System.out.println("가입성공");
		System.out.print("가입된 고객정보:");
		findView(c);
	}
	public void modifyView(Customer c) {
		System.out.println("수정 성공");
		System.out.print("수정된 고객정보:");
		findView(c);
	}
	public void removeView(Customer c) {
		System.out.println("삭제 성공");
		System.out.print("삭제된 고객정보:");
		findView(c);
	}
	public void loginView(Customer c) {
		System.out.println("로그인 성공");	
		System.out.print("로그인된 고객정보:");
		findView(c);
	}
}