package light.mvc.framework.listener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import light.mvc.framework.constant.GlobalConstant;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.sys.User;

public class SessionUserListener implements HttpSessionListener {
	// key为sessionId，value为HttpSession，使用static，定义静态变量，使之程序运行时，一直存在内存中。
	private static java.util.Map<String, HttpSession> sessionMap = new java.util.concurrent.ConcurrentHashMap<String, HttpSession>(
			500);

	/**
	 * HttpSessionListener中的方法，在创建session
	 */
	public void sessionCreated(HttpSessionEvent event) {
		
	    //我们把创建的session封装在一个map中  
        Map<String, HttpSession> map =(Map<String, HttpSession>) event.getSession().getServletContext().getAttribute("onLines");  
        if(map==null){//说明这是第一次访问是，需要自己new 一个对象  
            map=Collections.synchronizedMap(new HashMap<String, HttpSession>());//采用集合上锁，采用java 自带的上锁函数  
            event.getSession().getServletContext().setAttribute("onLines", map);  
        }  
//      System.out.println("listener添加一个了");  
        map.put(event.getSession().getId(), event.getSession());//以session 的id为key,session对象为value存在map中 
		
	}

	/**
	 * HttpSessionListener中的方法，回收session时,删除sessionMap中对应的session
	 */
	public void sessionDestroyed(HttpSessionEvent event) {
		getSessionMap().remove(event.getSession().getId());
		ServletContext ctx = event.getSession().getServletContext();
////		ctx.setAttribute("count", getUserSessions().size());
		int size = getUserSessions().size();
		ctx.setAttribute("lineCount", size);
	}

	/**
	 * 得到在线用户会话集合
	 */
	public static List<HttpSession> getUserSessions() {
		List<HttpSession> list = new ArrayList<HttpSession>();
		Iterator<String> iterator = getSessionMapKeySetIt();
		while (iterator.hasNext()) {
			String key = iterator.next();
			HttpSession session = getSessionMap().get(key);
			list.add(session);
		}
		return list;
	}

	/**
	 * 得到用户对应会话map，key为用户ID,value为会话ID
	 */
	public static Map<String, String> getUserSessionMap() {
		Map<String, String> map = new HashMap<String, String>();
		Iterator<String> iter = getSessionMapKeySetIt();
		while (iter.hasNext()) {
			String sessionId = iter.next();
			HttpSession session = getSessionMap().get(sessionId);
			SessionInfo user = (SessionInfo) session
					.getAttribute(GlobalConstant.SESSION_INFO);
			if (user != null) {
				map.put(user.getId().toString(), sessionId);
			}
		}
		return map;
	}

	/**
	 * 移除用户Session
	 */
	public synchronized static void removeUserSession(String userId) {
		Map<String, String> userSessionMap = getUserSessionMap();
		if (userSessionMap.containsKey(userId)) {
			String sessionId = userSessionMap.get(userId);
			getSessionMap().get(sessionId).invalidate();
			getSessionMap().remove(sessionId);
		}
	}

	/**
	 * 增加用户到session集合中
	 */
	public static void addUserSession(HttpSession session) {
		getSessionMap().put(session.getId(), session);
	}

	/**
	 * 移除一个session
	 */
	public static void removeSession(String sessionID) {
		getSessionMap().remove(sessionID);
	}

	public static boolean containsKey(String key) {
		return getSessionMap().containsKey(key);
	}

	/**
	 * 判断该用户是否已重复登录，使用 同步方法，只允许一个线程进入，才好验证是否重复登录
	 * 
	 * @param user
	 * @return
	 */
	public synchronized static boolean checkIfHasLogin(User user) {
		Iterator<String> iter = getSessionMapKeySetIt();
		while (iter.hasNext()) {
			String sessionId = iter.next();
			HttpSession session = getSessionMap().get(sessionId);
			SessionInfo sessionuser = (SessionInfo) session
					.getAttribute(GlobalConstant.SESSION_INFO);
			if (sessionuser != null) {
				if (sessionuser.getId().equals(user.getId())) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * 获取在线的sessionMap
	 */
	public static Map<String, HttpSession> getSessionMap() {
		return sessionMap;
	}

	/**
	 * 获取在线sessionMap中的SessionId
	 */
	public static Iterator<String> getSessionMapKeySetIt() {
		return getSessionMap().keySet().iterator();
	}
}
