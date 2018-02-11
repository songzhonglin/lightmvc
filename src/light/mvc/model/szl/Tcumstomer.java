package light.mvc.model.szl;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.validator.constraints.NotBlank;

import light.mvc.model.base.IdEntity;
@Entity
@Table(name="t_customer")
@DynamicInsert(true)
@DynamicUpdate(true)
public class Tcumstomer extends IdEntity implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String cust_name;
	
	private Integer cust_sex;
	private Integer cust_age; // 年龄
	private String cust_phone;
	private String cust_address;
	private String id_card;
	private String cust_webchat;
	private String cust_qq;
	private Long user_id;
	private String remark;
	private String img_path;
	private String cust_email;
	private Date createdatetime; // 创建时间
	
	@NotBlank
	public String getCust_name() {
		return cust_name;
	}
	
	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}
	public Integer getCust_sex() {
		return cust_sex;
	}
	public void setCust_sex(Integer cust_sex) {
		this.cust_sex = cust_sex;
	}
	public Integer getCust_age() {
		return cust_age;
	}
	public void setCust_age(Integer cust_age) {
		this.cust_age = cust_age;
	}
	@NotBlank
	public String getCust_phone() {
		return cust_phone;
	}
	public void setCust_phone(String cust_phone) {
		this.cust_phone = cust_phone;
	}
	
	public String getCust_address() {
		return cust_address;
	}
	public void setCust_address(String cust_address) {
		this.cust_address = cust_address;
	}
	public String getId_card() {
		return id_card;
	}
	public void setId_card(String id_card) {
		this.id_card = id_card;
	}
	public String getCust_webchat() {
		return cust_webchat;
	}
	public void setCust_webchat(String cust_webchat) {
		this.cust_webchat = cust_webchat;
	}
	public String getCust_qq() {
		return cust_qq;
	}
	public void setCust_qq(String cust_qq) {
		this.cust_qq = cust_qq;
	}
	
	public Long getUser_id() {
		return user_id;
	}
	public void setUser_id(Long user_id) {
		this.user_id = user_id;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATEDATETIME", length = 19)
	public Date getCreatedatetime() {
		return createdatetime;
	}
	public void setCreatedatetime(Date createdatetime) {
		this.createdatetime = createdatetime;
	}

	public String getImg_path() {
		return img_path;
	}

	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}

	public String getCust_email() {
		return cust_email;
	}

	public void setCust_email(String cust_email) {
		this.cust_email = cust_email;
	}
	
}
