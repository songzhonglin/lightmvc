package light.mvc.pageModel.szl;

import java.io.Serializable;
import java.util.Date;

public class OrderUnit implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2780807755520360752L;
	private Long id;
	private String unitName;
	private String creater;
	private String remark;
	private Date createTime; // 创建时间
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	
}
