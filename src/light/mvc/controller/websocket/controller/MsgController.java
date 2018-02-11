package light.mvc.controller.websocket.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.google.gson.GsonBuilder;

import light.mvc.controller.websocket.entity.Message;
import light.mvc.controller.websocket.websocket.MyWebSocketHandler;
import light.mvc.framework.constant.GlobalConstant;
import light.mvc.framework.listener.SessionUserListener;
import light.mvc.pageModel.base.Grid;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.sys.OnLineUser;
import light.mvc.pageModel.sys.User;
import light.mvc.utils.DateUtil;


@Controller
@RequestMapping("/msg")
public class MsgController {

	@Resource
	MyWebSocketHandler handler;

	// 跳转到交谈聊天页面
	@RequestMapping(value = "talk", method = RequestMethod.GET)
	public ModelAndView talk(Long to) {
		ModelAndView mv =new ModelAndView();
		mv.addObject("to",to);
		mv.setViewName("/webSocket/talk");
		return mv;
	}
	
	// 跳转到交谈聊天页面
	@RequestMapping(value = "toTalk", method = RequestMethod.GET)
	public ModelAndView toTalk() {
		ModelAndView mv =new ModelAndView();
		List<OnLineUser> list = new ArrayList<OnLineUser>();// 采用list装数据
		List<HttpSession> sessionList = SessionUserListener.getUserSessions();
		for (HttpSession session : sessionList) {
			OnLineUser onlineUser = new OnLineUser();
			onlineUser.setSessionId(session.getId());
			SessionInfo sessionuser = (SessionInfo) session.getAttribute(GlobalConstant.SESSION_INFO);
			if (sessionuser != null) {
				onlineUser.setId(sessionuser.getId().toString());
				onlineUser.setName(sessionuser.getName());
				onlineUser.setCreateTime(DateUtil.longToString(session.getCreationTime(), "yyyy-MM-dd HH-mm-ss"));
				onlineUser.setLastAccessedTime(
						DateUtil.longToString(session.getLastAccessedTime(), "yyyy-MM-dd HH-mm-ss"));
				onlineUser.setIp(sessionuser.getIp());
			}
			list.add(onlineUser);
		}

		mv.addObject("onlineUser", list);
		mv.setViewName("/webSocket/talks");
		return mv;
	}
	
	//然后把这个信息封装起来转给前台显示  
//    List<OnLineUser> list=new ArrayList<OnLineUser>();//采用list装数据 
//    List<HttpSession> sessionList = SessionUserListener.getUserSessions();
//    for(HttpSession session : sessionList){
//    	OnLineUser onlineUser = new OnLineUser();
//    	onlineUser.setSessionId(session.getId());
//		SessionInfo sessionuser = (SessionInfo) session
//				.getAttribute(GlobalConstant.SESSION_INFO);
//		if (sessionuser != null) {
//			onlineUser.setId(sessionuser.getId().toString());
//			onlineUser.setName(sessionuser.getName());
//			onlineUser.setCreateTime(DateUtil.longToString(session.getCreationTime(),"yyyy-MM-dd HH-mm-ss"));
//			onlineUser.setLastAccessedTime(DateUtil.longToString(session.getLastAccessedTime(),"yyyy-MM-dd HH-mm-ss"));
//			onlineUser.setIp(sessionuser.getIp());
//		}
//		list.add(onlineUser);
//    }
   

	// 跳转到发布广播页面
	@RequestMapping(value = "broadcast", method = RequestMethod.GET)
	public ModelAndView broadcast() {
		return new ModelAndView("/webSocket/broadcast");
	}

	// 发布系统广播（群发）
	@ResponseBody
	@RequestMapping(value = "broadcast", method = RequestMethod.POST)
	public void broadcast(String text) throws IOException {
		Message msg = new Message();
		msg.setDate(new Date());
		msg.setFrom(-1L);
		msg.setFromName("系统广播");
		msg.setTo(0L);
		msg.setText(text);
		handler.broadcast(new TextMessage(new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create().toJson(msg)));
	}
}
