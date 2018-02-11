package light.mvc.pageModel.szl;

import java.io.Serializable;
import java.util.Date;

public class OrderDetail implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2096246452342011894L;
	private Long id;
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
	
	private String goodsNameIds[];
	private String goodsQtys[];
	private String goodsUnitIds[];
	private String goodsPrices[];
	private String goodsSums[];
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
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	
	
}
