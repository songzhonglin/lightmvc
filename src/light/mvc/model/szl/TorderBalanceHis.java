package light.mvc.model.szl;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import light.mvc.model.base.IdEntity;

@Entity
@Table(name = "t_order_balance_his")
@DynamicInsert(true)
@DynamicUpdate(true)
public class TorderBalanceHis extends IdEntity implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8831977582435292423L;

	private String paymentPrice;// 支付价格
	private Integer paymentWay;
	private Date paymentTime;
	private Integer cleanStatus;
	private Date cleanTime;
	private Integer orderId;
	private Date createTime; // 创建时间
	private String creater;
	public String getPaymentPrice() {
		return paymentPrice;
	}
	public void setPaymentPrice(String paymentPrice) {
		this.paymentPrice = paymentPrice;
	}
	public Integer getPaymentWay() {
		return paymentWay;
	}
	public void setPaymentWay(Integer paymentWay) {
		this.paymentWay = paymentWay;
	}
	public Date getPaymentTime() {
		return paymentTime;
	}
	public void setPaymentTime(Date paymentTime) {
		this.paymentTime = paymentTime;
	}
	public Integer getCleanStatus() {
		return cleanStatus;
	}
	public void setCleanStatus(Integer cleanStatus) {
		this.cleanStatus = cleanStatus;
	}
	public Date getCleanTime() {
		return cleanTime;
	}
	public void setCleanTime(Date cleanTime) {
		this.cleanTime = cleanTime;
	}
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	
	

}
