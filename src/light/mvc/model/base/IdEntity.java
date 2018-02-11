package light.mvc.model.base;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

/**
 * 统一定义id的entity基类.
 * 
 * 基类统一定义id的属性名称、数据类型、列名映射及生成策略.
 * Oracle需要每个Entity独立定义id的SEQUCENCE时，不继承于本类而改为实现一个Idable的接口。
 * 
 * @author 鸵鸟
 */
@MappedSuperclass
public abstract class IdEntity {

	protected Long id;
	
//	@Version
//    @Column(name = "version")
//    protected int version;
//	
//	
//	@Column(name = "creator_id" , updatable = false)
//    protected String creatorId;
//    
//    @Column(name = "createTime" , updatable = false)
//    @Temporal(value=TemporalType.TIMESTAMP)
//    protected Date createTime;
    

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

//	public int getVersion() {
//		return version;
//	}
//
//	public void setVersion(int version) {
//		this.version = version;
//	}
//
//	public String getCreatorId() {
//		return creatorId;
//	}
//
//	public void setCreatorId(String creatorId) {
//		this.creatorId = creatorId;
//	}
	
}
