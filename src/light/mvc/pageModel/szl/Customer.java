package light.mvc.pageModel.szl;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class Customer implements java.io.Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long id;
	
	private String custName;
	private Integer custSex;
	private Integer custAge; // 年龄
	private String custPhone;
	private String custAddress;
	private String idCard;
	private String custWebchat;
	private String custQq;
	private Long userId;
	private String remark;
	private Date createDatetime; // 创建时间
	private String imgPath;
	private String custEmail;
	private MultipartFile sourceFile;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public Integer getCustSex() {
		return custSex;
	}
	public void setCustSex(Integer custSex) {
		this.custSex = custSex;
	}
	public Integer getCustAge() {
		return custAge;
	}
	public void setCustAge(Integer custAge) {
		this.custAge = custAge;
	}
	public String getCustPhone() {
		return custPhone;
	}
	public void setCustPhone(String custPhone) {
		this.custPhone = custPhone;
	}
	public String getCustAddress() {
		return custAddress;
	}
	public void setCustAddress(String custAddress) {
		this.custAddress = custAddress;
	}
	public String getIdCard() {
		return idCard;
	}
	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}
	public String getCustWebchat() {
		return custWebchat;
	}
	public void setCustWebchat(String custWebchat) {
		this.custWebchat = custWebchat;
	}
	public String getCustQq() {
		return custQq;
	}
	public void setCustQq(String custQq) {
		this.custQq = custQq;
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Date getCreateDatetime() {
		return createDatetime;
	}
	public void setCreateDatetime(Date createDatetime) {
		this.createDatetime = createDatetime;
	}
	public MultipartFile getSourceFile() {
		return sourceFile;
	}
	public void setSourceFile(MultipartFile sourceFile) {
		this.sourceFile = sourceFile;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public String getCustEmail() {
		return custEmail;
	}
	public void setCustEmail(String custEmail) {
		this.custEmail = custEmail;
	}
	
}
