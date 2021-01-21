# day11

실습.exerd파일 만들자

ERD를 그려서 테이블로 생성해보자 즉 포워드 엔지니어링을 하자

논리 모델링에서는 테이블 이름을 명사로 하되 한글로 만들고 물리 모델링에서 영문으로 만들 거다. 개발자 관점이 아니라 사용자 관점이다.

ctrl+enter 컬럼 이름을 만들 수 있다.

테이블 오른쪽 마우스> 특성

![1](https://user-images.githubusercontent.com/63957819/105337634-f50cdd00-5c1d-11eb-94fc-1525e2258cf8.png)

![2](https://user-images.githubusercontent.com/63957819/105337637-f63e0a00-5c1d-11eb-9d06-1ed3519c6758.png)

마찬가지로 자식1테이블을 만들자

![3](https://user-images.githubusercontent.com/63957819/105337639-f6d6a080-5c1d-11eb-8f26-428476ec5dc0.png)

![4](https://user-images.githubusercontent.com/63957819/105337641-f6d6a080-5c1d-11eb-9b23-889b1b8f1269.png)

새 비식별 관계를 만들자. 선택 할 때 자식이 부모를 참조하게 하려면 부모를 먼저 클릭 자식 쪽을 나중에 선택 해야 한다.

주 식별자 할 때 컬림1이 추가가 된다. 부모의 PK를 자식의 PK로 컬럼을 참조하게 바뀐다.

![5](https://user-images.githubusercontent.com/63957819/105337643-f76f3700-5c1d-11eb-9da2-530f8a4a4f32.png)

비식별자 선을 오른쪽 클릭> 특성>  자식 컬럼을 자식컬럼2로 바꿔보자

EXERD> 포워드 엔지니어링

여러 계정에서 쓰일수 있도록 스키마 표시 빼주자

테이블 생성,삭제, PK인덱스 생성,삭제 PK제약사항 생성,  코멘트 생성만 체크 해주자 >NEXT(오류 무시)> FINISH 

![6](https://user-images.githubusercontent.com/63957819/105337645-f76f3700-5c1d-11eb-9500-2b748a4ed5d6.png)

![7](https://user-images.githubusercontent.com/63957819/105337646-f807cd80-5c1d-11eb-9e54-b21e24cd8beb.png)

sqlplus에서 확인

![8](https://user-images.githubusercontent.com/63957819/105337648-f807cd80-5c1d-11eb-9f0d-bcb524157fc7.png)

![9](https://user-images.githubusercontent.com/63957819/105337650-f8a06400-5c1d-11eb-9c09-6f1fe58a801d.png)

VO클래스의 관계를 보자 Customer.java하고 person.java가 있다. 이 둘의 관계는 상속 관계이다.

Person클래스가 부모 역할을 하고 Customer가 자식의 역할을 하고 있다. IS A 관계가 성립한다.

Customer IS A Person : 상속, Account IS A Person : X 

계좌는 계좌 번호, 잔액, 이름이 있다. 이름이라는 변수를 직접 갖는 게 아니라 Person클래스 타입의 p라는 변수를 멤버 변수로 갖도록 하자 Account가 Person을 사용한다. 사용 관계 연관 관계라 한다. Account HAS A Person → HAS A 관계이다.

![10](https://user-images.githubusercontent.com/63957819/105337652-f8a06400-5c1d-11eb-9f0a-94ba5c2974e5.png)

JPA 는 자바를 이용한 영속성 유지 기술이라 한다. SQL 구문을 갖지 않고 예를 들어 Customer타입의 클래스 객체랑 Oracledb안에 있는 customer테이블이 있고 고객에 대한 행들이 있다 그 한 행과 계속 정보를 유지 시키는 맵핑 역할을 한다. 만약 customer객체 멤버 변수를 바꾸면 알아서 자동 테이블의 행 정보도 같이 바뀌게 된다. 거꾸로 행의 정보를 삭제를 해버리면 지금껏 연결되어있던 customer객체도 JVM메모리에서 없어지게 된다. 

SQL구문 없이도 알아서update, delete, select가 자동 처리가 된다.

---

![11](https://user-images.githubusercontent.com/63957819/105337655-f938fa80-5c1d-11eb-92a4-6063a5148948.png)

일반 사용자 입장에서 로그인 안된 상태에서는 주문전까지만 가능
고객은 모든일을 다 할 수 있다.
관리자는 상품추가, 주문자에 대한 일 통계, 월 통계등을 할거다.

고객클래스, 상품클래스, 주문에 관련된 클래스가 도출이 되어야 한다. 이러한 클래스를 vo클래스로 만들어주면 된다. 

고객 입장에서 주문 조회할 때 로그인을 한 다음 주문 조회를 할 거다. 주문 번호, 주문된 상품 번호, 상품 명, 상품의 가격이 얼마 짜리 인지 수량을 몇 개를 주문 했는지에 대한 정보가 나타나야 된다. 

![12](https://user-images.githubusercontent.com/63957819/105337657-f938fa80-5c1d-11eb-99d9-1d5b541659ea.png)

```java
PS C:\Users\User> sqlplus scott/tiger

SQL*Plus: Release 11.2.0.2.0 Production on 목 1월 21 10:55:47 2021

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL> desc product;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PROD_NO                                   NOT NULL VARCHAR2(5)
 PROD_NAME                                 NOT NULL VARCHAR2(50)
 PROD_PRICE

SQL> desc order_info
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL NUMBER
 ORDER_ID                                  NOT NULL VARCHAR2(5)
 ORDER_DT

SQL> desc order_line;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL NUMBER
 ORDER_PROD_NO                             NOT NULL VARCHAR2(5)
 ORDER_QUANTITY                            NOT NULL NUMBER(2)
```

먼저 scott계정에서 product테이블 구조를 살펴보자

- product.java

```java
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
		// TODO Auto-generated constructor stub
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
```

- OrderInfo.java

```java
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
```

- OrderLine.java

```java
package com.my.vo;

public class OrderLine {
/*
 * ORDER_NO                                  NOT NULL NUMBER
 ORDER_PROD_NO                             NOT NULL VARCHAR2(5)
 ORDER_QUANTITY                            NOT NULL NUMBER(2)
 */
	private int order_no;
	private Product p;
	private int order_quantitiy;
	
}
```

상품이름, 상품가격을 알기 위해서는 product 타입의 변수를 가져야 한다.

orderinfo에는 주문 기본정보가 들어있다. 

![13](https://user-images.githubusercontent.com/63957819/105337659-f9d19100-5c1d-11eb-9871-7ae2a9bcaabc.png)

주문기본 입장에서 주문상세 입장으로 가져야 할지  주문상세 입장에서 주문 기본정보를 갖고 있어야 할지 잘 결정해야 한다.  많이 사용되는 형태로 has a 관계를 설정하면 된다.

주문조회 한다면 주문 번호, 주문일자, 주문상세가 있을 거다. 주문상세에는 상품번호, 상품명, 가격, 수량이 있다.

관리자 모드 입장에서 주문내역을 확인해야 되는데 일단 주문번호, 주문일자, 주문자ID, 주문자 이름을 봐야 한다. 

클래스 설계 시에 vo관계 설정할 때 일단 private아니도록 멤버 변수만 쭉 만들고 has a관계인지 검증하고 다 되면 private으로 설정하고 생성자, set,get 메서드를 만들자.
