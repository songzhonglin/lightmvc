package light.mvc.model.szl;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import light.mvc.model.base.IdEntity;

@Entity
@Table(name="t_order_unit")
@DynamicInsert(true)
@DynamicUpdate(true)
public class TorderUnit extends IdEntity implements java.io.Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2445399825887348513L;
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
}
