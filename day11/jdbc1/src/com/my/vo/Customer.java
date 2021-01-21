package com.my.vo;

import java.io.Serializable;

public class Customer extends Person{	
	private String id;
	transient private String pwd;
	//private String name;	
	
	public Customer() {
		super();
	}
	public Customer(String id, String pwd) {
		super();
		this.id = id;
		this.pwd = pwd;
	}
	public Customer(String id, String pwd, String name) {
		this.id = id;
		this.pwd = pwd;
		this.name = name;
	}

	@Override
	public String toString() {
		return "Customer [id=" + id + ", pwd=" + pwd + ", name=" + name + "]";
	}
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
}
