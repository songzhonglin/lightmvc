package light.mvc.pageModel.szl;

import java.io.Serializable;
import java.util.Date;

public class Category implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -3629375095396629847L;
	private Long id;
	private String categoryCode;
	private String categoryName; // 
	private Date createTime; // 创建时间
	private String creater;
	private String remark;

	public String getCategoryCode() {
		return categoryCode;
	}

	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	
}
