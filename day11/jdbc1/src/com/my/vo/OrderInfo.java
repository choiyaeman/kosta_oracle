package com.my.vo;

import java.util.Date;
import java.util.List;

public class OrderInfo {
/*
 * ORDER_NO                                  NOT NULL NUMBER
 ORDER_ID                                  NOT NULL VARCHAR2(5)
 ORDER_DT                                           DATE
*/
	private int order_no;
	//private String order_id; 
	private Customer c; // order_id멤버변수를 customer타입의 has a 관계로 바꾸자
	private java.util.Date order_dt; //부모타입인 java.util의 Date로 사용하자
	private List<OrderLine> lines;
	public OrderInfo() {
		super();
	}
	public OrderInfo(Customer c) {
		this.c = c;
	}
	public OrderInfo(Customer c, List<OrderLine> lines) {
		this.c = c;
		this.lines = lines;
	}
	public OrderInfo(int order_no, Customer c, Date order_dt, List<OrderLine> lines) {
		super();
		this.order_no = order_no;
		this.c = c;
		this.order_dt = order_dt;
		this.lines = lines;
	}
	@Override
	public String toString() {
		return "OrderInfo [order_no=" + order_no + ", c=" + c + ", order_dt=" + order_dt + ", lines=" + lines + "]";
	}
	public int getOrder_no() {
		return order_no;
	}
	public void setOrder_no(int order_no) {
		this.order_no = order_no;
	}
	public Customer getC() {
		return c;
	}
	public void setC(Customer c) {
		this.c = c;
	}
	public java.util.Date getOrder_dt() {
		return order_dt;
	}
	public void setOrder_dt(java.util.Date order_dt) {
		this.order_dt = order_dt;
	}
	public List<OrderLine> getLines() {
		return lines;
	}
	public void setLines(List<OrderLine> lines) {
		this.lines = lines;
	}
	
	
}
