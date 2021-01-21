package com.my.control;

import java.util.List;

import com.my.exception.AddException;
import com.my.exception.FindException;
import com.my.exception.ModifyException;
import com.my.exception.RemoveException;
import com.my.service.CustomerService;
import com.my.share.CustomerShare;
import com.my.view.CustomerSuccessView;
//import com.my.view.CustomerView;
import com.my.view.FailView;
import com.my.vo.Customer;

public class CustomerController {
	private CustomerService service = 
			   new CustomerService();
	private CustomerSuccessView successView = 
				new CustomerSuccessView();
	private FailView failView =
			    new FailView();
	public void findAll() {
		try {
			List<Customer> cAll = 
					service.findAll();
			for(int i=0; i<cAll.size(); i++) {
				Customer c = cAll.get(i);
				successView.findView(c);
			}
		}catch(FindException e) {
			//System.out.println(e.getMessage());
			failView.printMessage(e.getMessage());
		}
	}
	public void add(Customer c) {
		try {
			service.add(c);
			successView.addView(c);
		} catch (AddException e) {
			failView.printMessage(e.getMessage());
		}
	}
	public void findById(String id) {
		try {
			Customer c = service.findById(id);
			successView.findView(c);
		} catch (FindException e) {
			failView.printMessage(e.getMessage());
		}
	}
	public void modify(Customer c) {
		try {
			Customer result = service.modify(c);
			successView.modifyView(result);
		} catch (ModifyException e) {
			failView.printMessage(e.getMessage());
		}
	}
	public void remove(String id) {
		try {
			Customer c = service.remove(id);
			successView.removeView(c);
		} catch (RemoveException e) {
			failView.printMessage(e.getMessage());
		}
	}
	public void login(String id, String pwd) {
		try {
			Customer c = service.login(id, pwd);			
			//------------------------
			CustomerShare.loginedId = id;
			//------------------------
			successView.loginView(c);
		} catch (FindException e) {
			failView.printMessage(e.getMessage());
		}
	}
	public void logout() {
		CustomerShare.loginedId = null;
	}
}