package light.mvc.pageModel.sys;

import java.io.Serializable;

public class OnLineUser  implements Serializable{
	
	private String sessionId;
	private String id;
	private String createTime;
	private String LastAccessedTime;
	private String ip;
	private String name; // 登录名
	
	
	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getLastAccessedTime() {
		return LastAccessedTime;
	}
	public void setLastAccessedTime(String lastAccessedTime) {
		LastAccessedTime = lastAccessedTime;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

}
