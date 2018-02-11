package light.mvc.pageModel.szl;

import java.io.Serializable;
import java.util.Date;

public class OrderDate implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8060425982073862216L;
	private Long id;
	private Date orderDate;
	private String total;
	public Long getId() {
		return id;
	}
	
	
	public String getTotal() {
		return total;
	}


	public void setTotal(String total) {
		this.total = total;
	}


	public void setId(Long id) {
		this.id = id;
	}
	public Date getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}
	
}
