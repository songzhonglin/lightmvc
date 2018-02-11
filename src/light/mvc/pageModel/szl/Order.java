package light.mvc.pageModel.szl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import light.mvc.model.szl.TorderDate;
import light.mvc.model.szl.TorderDetail;

public class Order implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1836426296362280906L;
	private Long id;
	private String orderCode;
	private String reciever;
	private String recieverPhone;
	private String deliveryAddress;
	private String totalPrice;// 总计价格
	private String actualPrice;// 实付款
	private String payment;//已付款
	private String notPayment;// 未付款
	private Date createTimeStart;
	private Date createTimeEnd;
	private Integer paymentWay;// 支付方式
	private Date paymentDate;//支付时间
	private Integer cleanStatus;// 结算状态
	private Date cleanDate;// 结算时间
	private String creater;
	private Date createTime; // 创建时间
	private String goodsNameIds[];
	private String goodsQtys[];
	private String goodsUnitIds[];
	private String goodsPrices[];
	private String goodsSums[];
	private String detailIds[];
	private Date orderDate;
	private String orderDateIds[];
	private String orderDateId[];// 订单明细对应订单时间的id
	private Date orderDates[]; 
	private List<TorderDate> orderDateList =new ArrayList<TorderDate>();
	
	private List<TorderDetail> orderDetailList =new ArrayList<TorderDetail>();
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getOrderCode() {
		return orderCode;
	}
	public void setOrderCode(String orderCode) {
		this.orderCode = orderCode;
	}
	public String getReciever() {
		return reciever;
	}
	public void setReciever(String reciever) {
		this.reciever = reciever;
	}
	public String getRecieverPhone() {
		return recieverPhone;
	}
	public void setRecieverPhone(String recieverPhone) {
		this.recieverPhone = recieverPhone;
	}
	public String getDeliveryAddress() {
		return deliveryAddress;
	}
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	public String getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(String totalPrice) {
		this.totalPrice = totalPrice;
	}
	public String getActualPrice() {
		return actualPrice;
	}
	public void setActualPrice(String actualPrice) {
		this.actualPrice = actualPrice;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public Date getCreateTimeStart() {
		return createTimeStart;
	}
	public void setCreateTimeStart(Date createTimeStart) {
		this.createTimeStart = createTimeStart;
	}
	public Date getCreateTimeEnd() {
		return createTimeEnd;
	}
	public void setCreateTimeEnd(Date createTimeEnd) {
		this.createTimeEnd = createTimeEnd;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Integer getPaymentWay() {
		return paymentWay;
	}
	public void setPaymentWay(Integer paymentWay) {
		this.paymentWay = paymentWay;
	}
	public String[] getGoodsNameIds() {
		return goodsNameIds;
	}
	public void setGoodsNameIds(String[] goodsNameIds) {
		this.goodsNameIds = goodsNameIds;
	}
	public String[] getGoodsQtys() {
		return goodsQtys;
	}
	public void setGoodsQtys(String[] goodsQtys) {
		this.goodsQtys = goodsQtys;
	}
	public String[] getGoodsUnitIds() {
		return goodsUnitIds;
	}
	public void setGoodsUnitIds(String[] goodsUnitIds) {
		this.goodsUnitIds = goodsUnitIds;
	}
	public String[] getGoodsPrices() {
		return goodsPrices;
	}
	public void setGoodsPrices(String[] goodsPrices) {
		this.goodsPrices = goodsPrices;
	}
	public String[] getGoodsSums() {
		return goodsSums;
	}
	public void setGoodsSums(String[] goodsSums) {
		this.goodsSums = goodsSums;
	}
	public Date getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}
	public String[] getDetailIds() {
		return detailIds;
	}
	public void setDetailIds(String[] detailIds) {
		this.detailIds = detailIds;
	}
	public String[] getOrderDateIds() {
		return orderDateIds;
	}
	public void setOrderDateIds(String[] orderDateIds) {
		this.orderDateIds = orderDateIds;
	}
	public String[] getOrderDateId() {
		return orderDateId;
	}
	public void setOrderDateId(String[] orderDateId) {
		this.orderDateId = orderDateId;
	}
	public Date[] getOrderDates() {
		return orderDates;
	}
	public void setOrderDates(Date[] orderDates) {
		this.orderDates = orderDates;
	}
	public List<TorderDate> getOrderDateList() {
		return orderDateList;
	}
	public void setOrderDateList(List<TorderDate> orderDateList) {
		this.orderDateList = orderDateList;
	}
	public List<TorderDetail> getOrderDetailList() {
		return orderDetailList;
	}
	public void setOrderDetailList(List<TorderDetail> orderDetailList) {
		this.orderDetailList = orderDetailList;
	}
	public String getPayment() {
		return payment;
	}
	public void setPayment(String payment) {
		this.payment = payment;
	}
	public String getNotPayment() {
		return notPayment;
	}
	public void setNotPayment(String notPayment) {
		this.notPayment = notPayment;
	}
	public Date getPaymentDate() {
		return paymentDate;
	}
	public void setPaymentDate(Date paymentDate) {
		this.paymentDate = paymentDate;
	}
	public Integer getCleanStatus() {
		return cleanStatus;
	}
	public void setCleanStatus(Integer cleanStatus) {
		this.cleanStatus = cleanStatus;
	}
	public Date getCleanDate() {
		return cleanDate;
	}
	public void setCleanDate(Date cleanDate) {
		this.cleanDate = cleanDate;
	}
	
}
