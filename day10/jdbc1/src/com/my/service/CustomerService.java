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
	private CustomerDAO dao = new CustomerDAOOracle(); //upcasting
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
