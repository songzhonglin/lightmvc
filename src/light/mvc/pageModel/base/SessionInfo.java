package light.mvc.pageModel.base;

import java.util.List;

public class SessionInfo implements java.io.Serializable {

	public static List<String> userIsLogin;
	private Long id;// 用户ID
	private String loginname;// 登录名
	private String name;// 姓名
	private String ip;// 用户IP
	private Integer usertype; // 用户类型
	
	private String onLineCount; // 在线人数
	
	
	private String isinitpwd;

	private List<String> resourceList;// 用户可以访问的资源地址列表
	
	private List<String> resourceAllList;

	public List<String> getResourceList() {
		return resourceList;
	}

	public void setResourceList(List<String> resourceList) {
		this.resourceList = resourceList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getLoginname() {
		return loginname;
	}

	public void setLoginname(String loginname) {
		this.loginname = loginname;
	}
	
	public List<String> getResourceAllList() {
		return resourceAllList;
	}

	public void setResourceAllList(List<String> resourceAllList) {
		this.resourceAllList = resourceAllList;
	}

	@Override
	public String toString() {
		return this.name;
	}

	public Integer getUsertype() {
		return usertype;
	}

	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
	}

	public String getIsinitpwd() {
		return isinitpwd;
	}

	public void setIsinitpwd(String isinitpwd) {
		this.isinitpwd = isinitpwd;
	}

	public String getOnLineCount() {
		return onLineCount;
	}

	public void setOnLineCount(String onLineCount) {
		this.onLineCount = onLineCount;
	}

	public List<String> getUserIsLogin() {
		return userIsLogin;
	}

	public void setUserIsLogin(List<String> userIsLogin) {
		this.userIsLogin = userIsLogin;
	}

	
	


}
