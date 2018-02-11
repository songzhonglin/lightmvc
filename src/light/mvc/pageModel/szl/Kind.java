package light.mvc.pageModel.szl;

import java.io.Serializable;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class Kind implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2000255694622445290L;
	private Long id;
	private String kindCode;
	private String kindName; // 种类名称
	private String categoryName; // 品类名称
	private String imgPath;
	private Integer categoryId;
	private Date createTime; // 创建时间
	private String creater;
	private String remark;
	private MultipartFile sourceFile;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getKindCode() {
		return kindCode;
	}
	public void setKindCode(String kindCode) {
		this.kindCode = kindCode;
	}
	public String getKindName() {
		return kindName;
	}
	public void setKindName(String kindName) {
		this.kindName = kindName;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public Integer getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
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
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public MultipartFile getSourceFile() {
		return sourceFile;
	}
	public void setSourceFile(MultipartFile sourceFile) {
		this.sourceFile = sourceFile;
	}
	
}
