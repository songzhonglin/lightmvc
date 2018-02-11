package light.mvc.controller.websocket.websocket;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import light.mvc.controller.websocket.entity.Message;
import light.mvc.pageModel.sys.User;



/**
 * Socket处理器
 * 
 * @author songzhonglin
 * @date 2017年12月22日 上午8:53:07
 */
@Component
public class MyWebSocketHandler implements WebSocketHandler {

	public static final Map<Long, WebSocketSession> userSocketSessionMap;
	public static final Map<Long, String> userSocketMap;

	static {
		userSocketSessionMap = new HashMap<Long, WebSocketSession>();
		userSocketMap = new HashMap<Long,String>();
	}

	/**
	 * 关闭连接后
	 */
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		System.out.println("Websocket:" + session.getId() + "已经关闭");
		Iterator<Entry<Long, WebSocketSession>> it = userSocketSessionMap
				.entrySet().iterator();
		// 移除Socket会话
		while (it.hasNext()) {
			Entry<Long, WebSocketSession> entry = it.next();
			if (entry.getValue().getId().equals(session.getId())) {
				userSocketSessionMap.remove(entry.getKey());
				userSocketMap.remove(entry.getKey());
				System.out.println("Socket会话已经移除:用户ID" + entry.getKey());
				break;
			}
		}

	}

	/**
	 * 建立连接后
	 */
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		Long uid = (Long) session.getAttributes().get("uid");
		String name = (String) session.getAttributes().get("name");
		if (userSocketSessionMap.get(uid) == null) {
			userSocketSessionMap.put(uid, session);
			userSocketMap.put(uid, name);
		}

	}

	/**
	 * 消息处理，在客户端通过Websocket API发送的消息会经过这里，然后进行相应的处理
	 */
	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		if (message.getPayloadLength() == 0)
			return;
		Message msg=new Gson().fromJson(message.getPayload().toString(),Message.class);
		msg.setDate(new Date());
		sendMessageToUser(msg.getTo(), new TextMessage(new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create().toJson(msg)));

	}
	/**
	 * 消息传输错误处理
	 */
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		if (session.isOpen()) {
			session.close();
		}
		Iterator<Entry<Long, WebSocketSession>> it = userSocketSessionMap
				.entrySet().iterator();
		// 移除Socket会话
		while (it.hasNext()) {
			Entry<Long, WebSocketSession> entry = it.next();
			if (entry.getValue().getId().equals(session.getId())) {
				userSocketSessionMap.remove(entry.getKey());
				userSocketMap.remove(entry.getKey());
				System.out.println("Socket会话已经移除:用户ID" + entry.getKey());
				break;
			}
		}

	}
	/**
	 * 给所有在线用户发送消息
	 * 
	 * @param message
	 * @throws IOException
	 */
	public void broadcast(final TextMessage message) throws IOException {
		Iterator<Entry<Long, WebSocketSession>> it = userSocketSessionMap
				.entrySet().iterator();

		// 多线程群发
		while (it.hasNext()) {

			final Entry<Long, WebSocketSession> entry = it.next();

			if (entry.getValue().isOpen()) {
				// entry.getValue().sendMessage(message);
				new Thread(new Runnable() {

					public void run() {
						try {
							if (entry.getValue().isOpen()) {
								entry.getValue().sendMessage(message);
							}
						} catch (IOException e) {
							e.printStackTrace();
						}
					}

				}).start();
			}

		}
	}

	@Override
	public boolean supportsPartialMessages() {
		// TODO Auto-generated method stub
		return false;
	}
	
	/**
	 * 给某个用户发送消息
	 * 
	 * @param userName
	 * @param message
	 * @throws IOException
	 */
	public void sendMessageToUser(Long uid, TextMessage message)
			throws IOException {
		WebSocketSession session = userSocketSessionMap.get(uid);
		if (session != null && session.isOpen()) {
			session.sendMessage(message);
		}
	}
	
	public List<User> onLineUsers(){
		Iterator<Entry<Long, WebSocketSession>> it = userSocketSessionMap
				.entrySet().iterator();
		List<User> listUser= new ArrayList<User>();
		while (it.hasNext()) {
			User user =new User();
			
			Entry<Long, WebSocketSession> entry = it.next();
				Long uid = entry.getKey();
				String name = userSocketMap.get(entry.getKey());
				user.setId(uid);
				user.setLoginname(name);
				listUser.add(user);
		}
		
		return listUser;
	}

}
