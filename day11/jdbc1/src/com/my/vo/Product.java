package com.my.vo;

public class Product {
	/*
	 PROD_NO                                   NOT NULL VARCHAR2(5)
	 PROD_NAME                                 NOT NULL VARCHAR2(50)
	 PROD_PRICE                                         NUMBER(7)
	 */
	private String prod_no; //외부에서 접근 못하도록 private설정
	private String prod_name;
	private String prod_price;
	public Product() {
		super();
	}
	public Product(String prod_no, String prod_name, String prod_price) {
		super();
		this.prod_no = prod_no;
		this.prod_name = prod_name;
		this.prod_price = prod_price;
	}
	
	@Override
	public String toString() {
		return "Product [prod_no=" + prod_no + ", prod_name=" + prod_name + ", prod_price=" + prod_price + "]";
	}
	
	public String getProd_no() {
		return prod_no;
	}
	public void setProd_no(String prod_no) {
		this.prod_no = prod_no;
	}
	public String getProd_name() {
		return prod_name;
	}
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	public String getProd_price() {
		return prod_price;
	}
	public void setProd_price(String prod_price) {
		this.prod_price = prod_price;
	}

}
