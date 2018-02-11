package light.mvc.model.szl;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import light.mvc.model.base.IdEntity;

@Entity
@Table(name="t_order_detail")
@DynamicInsert(true)
@DynamicUpdate(true)
public class TorderDetail extends IdEntity implements java.io.Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1195933634576361561L;
	private Integer goodsNameId;
	private String goodsName;
	private String goodsQty;
	private Integer goodsUnitId;
	private String goodsUnit;
	private String goodsPrice;
	private String goodsSum;
	private Integer cleanStatus;
	private Date cleanDate;
	private String cleanPrice;
	private Integer cleanWay;
	private Integer orderDateId;
	private String creater;
	private Date createTime; // 创建时间
	
	
	public Integer getGoodsNameId() {
		return goodsNameId;
	}
	public void setGoodsNameId(Integer goodsNameId) {
		this.goodsNameId = goodsNameId;
	}
	public String getGoodsName() {
		return goodsName;
	}
	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}
	public String getGoodsQty() {
		return goodsQty;
	}
	public void setGoodsQty(String goodsQty) {
		this.goodsQty = goodsQty;
	}
	public Integer getGoodsUnitId() {
		return goodsUnitId;
	}
	public void setGoodsUnitId(Integer goodsUnitId) {
		this.goodsUnitId = goodsUnitId;
	}
	public String getGoodsUnit() {
		return goodsUnit;
	}
	public void setGoodsUnit(String goodsUnit) {
		this.goodsUnit = goodsUnit;
	}
	public String getGoodsPrice() {
		return goodsPrice;
	}
	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}
	public String getGoodsSum() {
		return goodsSum;
	}
	public void setGoodsSum(String goodsSum) {
		this.goodsSum = goodsSum;
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
	public String getCleanPrice() {
		return cleanPrice;
	}
	public void setCleanPrice(String cleanPrice) {
		this.cleanPrice = cleanPrice;
	}
	public Integer getCleanWay() {
		return cleanWay;
	}
	public void setCleanWay(Integer cleanWay) {
		this.cleanWay = cleanWay;
	}
	public Integer getOrderDateId() {
		return orderDateId;
	}
	public void setOrderDateId(Integer orderDateId) {
		this.orderDateId = orderDateId;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
	
}
