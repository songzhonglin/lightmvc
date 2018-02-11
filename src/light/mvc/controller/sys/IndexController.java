package light.mvc.controller.sys;

import java.util.HashSet;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import light.mvc.controller.base.BaseController;
import light.mvc.framework.constant.GlobalConstant;
import light.mvc.framework.listener.SessionUserListener;
import light.mvc.pageModel.base.Json;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.sys.User;
import light.mvc.service.sys.ResourceServiceI;
import light.mvc.service.sys.UserServiceI;
import light.mvc.utils.IpUtil;

@Controller
@RequestMapping("/admin")
public class IndexController extends BaseController {

	@Autowired
	private UserServiceI userService;

	@Autowired
	private ResourceServiceI resourceService;

	@RequestMapping("/index")
	public String index(HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		if ((sessionInfo != null) && (sessionInfo.getId() != null)) {
			return "/index";
		}
		return "/login";
	}

	@ResponseBody
	@RequestMapping("/login")
	public Json login(User user, HttpSession session, HttpServletRequest request) {
		// Json j = new Json();
		// RequestContext rc=new RequestContext(request);
		// String nickName=Util.getNickName();
		// System.out.println(nickName);
		// User sysuser = userService.login(user);
		// if (sysuser != null) {
		// if (sysuser.getState() == 1) {
		// j.setMsg("该账号已被停止使用，请联系管理员！");
		// } else {
		// j.setSuccess(true);
		// j.setMsg("登陆成功！");
		// SessionInfo sessionInfo = new SessionInfo();
		//
		// String initPwd=MD5Util.md5("00000");
		// if(initPwd.equals(sysuser.getPassword())){
		// sessionInfo.setIsinitpwd("1");
		// }else{
		// sessionInfo.setIsinitpwd("0");
		// }
		// sessionInfo.setId(sysuser.getId());
		// sessionInfo.setLoginname(sysuser.getLoginname());
		// sessionInfo.setName(sysuser.getName());
		// sessionInfo.setUsertype(sysuser.getUsertype());
		// sessionInfo.setIp(IpUtil.getIpAddress(request));
		// sessionInfo.setResourceList(userService.listResource(sysuser.getId()));
		// sessionInfo.setResourceAllList(resourceService.listAllResource());
		// session.setAttribute(GlobalConstant.SESSION_INFO, sessionInfo);
		// }
		// } else {
		// String msg=rc.getMessage("user.pwd.error");
		// j.setMsg(msg);
		// }
		// return j;

		Json j = new Json();
		User sysuser = userService.login(user);
		if (sysuser != null) {
			if (sysuser.getState() == 1) {
				j.setMsg("该账号已被停止使用，请联系管理员！");
			} else {
				// 验证该用户ID，是否已经登录。当前用户比较已登录到系统的静态变量中的值，是否存在。
				Boolean hasLogin = SessionUserListener.checkIfHasLogin(sysuser);
				if (hasLogin) {
					j.setMsg("该用户【" + sysuser.getLoginname() + "】已登录，请先退出再登录！");
				} else {
					// 比较保存所有用户session的静态变量中，是否含有当前session的键值映射，如果含有就删除
					if (SessionUserListener.containsKey(request.getSession().getId())) {
						SessionUserListener.removeSession(request.getSession().getId());
					}
					// 把当前用户封装的session按，sessionID和session进行键值封装，添加到静态变量map中。
					SessionUserListener.addUserSession(request.getSession());
					session.setAttribute("loginname", sysuser.getLoginname()); // 将用户名存入session
					
					// webSocket使用
					session.setAttribute("uid", sysuser.getId());
					session.setAttribute("name", sysuser.getName());

					SessionInfo sessionInfo = new SessionInfo();
					sessionInfo.setId(sysuser.getId());
					// SessionInfo.userIsLogin.add(sysuser.getLoginname());
					sessionInfo.setLoginname(sysuser.getLoginname());
					sessionInfo.setName(sysuser.getName());
					sessionInfo.setUsertype(sysuser.getUsertype());
					sessionInfo.setIp(IpUtil.getIpAddress(request));
					sessionInfo.setResourceList(userService.listResource(sysuser.getId()));
					sessionInfo.setResourceAllList(resourceService.listAllResource());
					session.setAttribute(GlobalConstant.SESSION_INFO, sessionInfo);

					ServletContext context = session.getServletContext();
					// 打印在线人数
					System.out.println("在线人数：" + context.getAttribute("lineCount"));
					
					int size = SessionUserListener.getUserSessions().size();
					
					context.setAttribute("lineCount", size);

					j.setSuccess(true);
					j.setMsg("登陆成功！");
				}
			}
		} else {
			j.setMsg("用户名或密码错误！");
		}
		return j;
	}

	@ResponseBody
	@RequestMapping("/logout")
	public Json logout(HttpSession session) {
//		ServletContext context = session.getServletContext();
//		int lineCount = (Integer) context.getAttribute("lineCount");
//		context.setAttribute("lineCount", lineCount - 1);
//		HashSet<HttpSession> sessionSet = (HashSet<HttpSession>) context.getAttribute("sessionSet");
//		if (sessionSet != null) {
//			sessionSet.remove(session);
//			context.setAttribute("sessionSet", sessionSet);  
//		}
		
//		int size = SessionUserListener.getUserSessions().size();
//		
//		context.setAttribute("lineCount", size -1 );

		Json j = new Json();
		if (session != null) {
			session.invalidate();
		}
		j.setSuccess(true);
		j.setMsg("注销成功！");

		return j;
	}
}
