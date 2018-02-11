package light.mvc.socket;

import java.awt.BorderLayout;
import java.awt.TextArea;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;

public class ChatClient {
	Socket s = null;  
	 DataOutputStream dos = null;  
	 DataInputStream dis = null;  
	 private boolean bConnected = false;  
	 TextField tfTxt = new TextField();  
	 TextArea taContent = new TextArea();  
	 Thread tRecv = new Thread(new RecvThread());  
	 public static void main(String[] args) {  
	  new ChatClient().launchFrame();   
	 }  
	  
	 public void launchFrame() {  
	  setLocation(400, 300);  
	  this.setSize(300, 300);  
	  add(tfTxt, BorderLayout.SOUTH);  
	  add(taContent, BorderLayout.NORTH);  
	  pack();  
	  this.addWindowListener(new WindowAdapter() {  
	  
	   @Override  
	   public void windowClosing(WindowEvent arg0) {  
	    disconnect();  
	    System.exit(0);  
	   }  
	     
	  });  
	  tfTxt.addActionListener(new TFListener());  
//	  setVisible(true);  
	  connect();  
	    
	  tRecv.start();  
	 }  
	   
	 private void addWindowListener(WindowAdapter windowAdapter) {
		// TODO Auto-generated method stub
		
	}

	private void pack() {
		// TODO Auto-generated method stub
		
	}

	private void add(TextArea taContent2, String north) {
		// TODO Auto-generated method stub
		
	}

	private void add(TextField tfTxt2, String south) {
		// TODO Auto-generated method stub
		
	}

	private void setSize(int i, int j) {
		// TODO Auto-generated method stub
		
	}

	private void setLocation(int i, int j) {
		// TODO Auto-generated method stub
		
	}

	public void connect() {  
	  try {  
	   s = new Socket("127.0.0.1", 8888);  
	   dos = new DataOutputStream(s.getOutputStream());  
	   dis = new DataInputStream(s.getInputStream());  
	System.out.println("connected!");  
	   bConnected = true;  
	  } catch (UnknownHostException e) {  
	   e.printStackTrace();  
	  } catch (IOException e) {  
	   e.printStackTrace();  
	  }  
	    
	 }  
	   
	 public void disconnect() {  
	  try {  
	   dos.close();  
	   dis.close();  
	   s.close();  
	  } catch (IOException e) {  
	   e.printStackTrace();  
	  }  
	    
	   }  
	   
	 private class TFListener implements ActionListener {  
	  
	  public void actionPerformed(ActionEvent e) {  
	   String str = tfTxt.getText().trim();  
	   tfTxt.setText("");  
	     
	   try {  
	    dos.writeUTF(str);  
	    dos.flush();  
	   } catch (IOException e1) {  
	    e1.printStackTrace();  
	   }  
	     
	  }  
	    
	 }  
	   
	 private class RecvThread implements Runnable {  
	  
	  public void run() {  
	   try {  
	    while(bConnected) {  
	     String str = dis.readUTF();  
	       
	     taContent.setText(taContent.getText() + str + '\n');  
	    }  
	   } catch (SocketException e) {  
	    System.out.println("bye!");  
	   } catch (IOException e) {  
	    e.printStackTrace();  
	   }   
	     
	  }  
	    
	 }  
}
