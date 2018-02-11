package light.mvc.controller.sys;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import light.mvc.controller.base.BaseController;
import light.mvc.framework.constant.GlobalConstant;
import light.mvc.framework.listener.SessionUserListener;
import light.mvc.pageModel.base.Grid;
import light.mvc.pageModel.base.Json;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.sys.OnLineUser;
import light.mvc.pageModel.sys.User;
import light.mvc.service.base.ServiceException;
import light.mvc.service.sys.UserServiceI;
import light.mvc.utils.DateUtil;
import light.mvc.utils.ExcelExportUtil;

@Controller
@RequestMapping("/user")
public class UserController extends BaseController {

	@Autowired
	private UserServiceI userService;

	@RequestMapping("/manager")
	public String manager() {
		return "/admin/user";
	}

	@RequestMapping("/toOnline")
	public String toOnline() {
		return "/admin/onLineUser";
	}

	@RequestMapping("/onLineUser")
	@ResponseBody
	public Grid onLineUser(PageFilter ph, HttpServletRequest request, HttpServletResponse response) {
		//然后把这个信息封装起来转给前台显示  
        List<OnLineUser> list=new ArrayList<OnLineUser>();//采用list装数据 
        List<HttpSession> sessionList = SessionUserListener.getUserSessions();
        for(HttpSession session : sessionList){
        	OnLineUser onlineUser = new OnLineUser();
        	onlineUser.setSessionId(session.getId());
			SessionInfo sessionuser = (SessionInfo) session
					.getAttribute(GlobalConstant.SESSION_INFO);
			if (sessionuser != null) {
				onlineUser.setId(sessionuser.getId().toString());
				onlineUser.setName(sessionuser.getName());
				onlineUser.setCreateTime(DateUtil.longToString(session.getCreationTime(),"yyyy-MM-dd HH-mm-ss"));
				onlineUser.setLastAccessedTime(DateUtil.longToString(session.getLastAccessedTime(),"yyyy-MM-dd HH-mm-ss"));
				onlineUser.setIp(sessionuser.getIp());
			}
			list.add(onlineUser);
        }
       
		Grid grid = new Grid();
		grid.setRows(list);
		int size = list.size();
		Long l = new Long((long)size);
		grid.setTotal(l);
		return grid;
	}
	
	@RequestMapping("/kitLogin")
	@ResponseBody
	public Json kitLogin(Long id) {
		Json j = new Json();
		try {
			SessionUserListener.removeUserSession(id.toString());
			j.setMsg("强制下线成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}
	
	

	@RequestMapping("/dataGrid")
	@ResponseBody
	public Grid dataGrid(User user, PageFilter ph) {
		Grid grid = new Grid();
		grid.setRows(userService.dataGrid(user, ph));
		grid.setTotal(userService.count(user, ph));
		return grid;
	}

	@RequestMapping("/editPwdPage")
	public String editPwdPage() {
		return "/admin/userEditPwd";
	}

	@RequestMapping("/editUserPwd")
	@ResponseBody
	public Json editUserPwd(HttpServletRequest request, String oldPwd, String pwd) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			boolean resultFlag = userService.editUserPwd(sessionInfo, oldPwd, pwd);
			if (resultFlag) {
				j.setSuccess(true);
				j.setMsg("密码修改成功！");
			} else {
				j.setMsg("原始密码输入不正确，请重新输入！");
			}
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/addPage")
	public String addPage() {
		return "/admin/userAdd";
	}

	@RequestMapping("/add")
	@ResponseBody
	public Json add(User user) {
		Json j = new Json();
		User u = userService.getByLoginName(user);
		if (u != null) {
			j.setMsg("用户名已存在!");
		} else {
			try {
				userService.add(user);
				j.setSuccess(true);
				j.setMsg("添加成功！");
			} catch (Exception e) {
				j.setMsg(e.getMessage());
			}

		}
		return j;
	}

	@RequestMapping("/get")
	@ResponseBody
	public User get(Long id) {
		return userService.get(id);
	}

	@RequestMapping("/delete")
	@ResponseBody
	public Json delete(Long id) {
		Json j = new Json();
		try {
			userService.delete(id);
			j.setMsg("删除成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		User u = userService.get(id);
		request.setAttribute("user", u);
		return "/admin/userEdit";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(User user) {
		Json j = new Json();
		try {
			userService.edit(user);
			j.setSuccess(true);
			j.setMsg("编辑成功！");
		} catch (ServiceException e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/export")
	@ResponseBody
	public Json exportExcel(User user, PageFilter ph, HttpServletRequest request, HttpServletResponse response) {
		Json j = new Json();
		List<User> userList = userService.dataGrid(user, ph);
		String fileName = "用户信息导出";
		LinkedList<Map<String, String>> list = createExcelRecord(userList);
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		try {
			ExcelExportUtil.generateExcel(list, fileName).write(os);
			ExcelExportUtil.createStream(response, fileName, os);
			j.setMsg("导出excel成功！");
			j.setSuccess(true);
		} catch (IOException e) {
			j.setMsg(e.getMessage());
			e.printStackTrace();
		}
		return j;
	}

	// 导出设置值
	private LinkedList<Map<String, String>> createExcelRecord(List<User> userList) {
		LinkedList<Map<String, String>> listmap = new LinkedList<Map<String, String>>();
		User user = null;
		for (int j = 0; j < userList.size(); j++) {
			user = userList.get(j);
			LinkedHashMap<String, String> mapValue = new LinkedHashMap<String, String>();
			mapValue.put("序号", user.getId().toString());
			mapValue.put("登录名", user.getLoginname());
			mapValue.put("用户名", user.getName());
			mapValue.put("所属部门", user.getOrganizationName());
			mapValue.put("性别", user.getSex() == 0 ? "男" : "女");
			mapValue.put("电话", user.getPhone());
			mapValue.put("用户类型", user.getUsertype() == 0 ? "管理员" : "用户");
			mapValue.put("是否默认", user.getIsdefault() == 0 ? "默认" : "否");
			mapValue.put("状态", user.getState() == 0 ? "正常" : "停用");
			mapValue.put("创建时间 ", user.getCreatedatetime().toString());
			listmap.add(mapValue);
		}
		return listmap;
	}
}
