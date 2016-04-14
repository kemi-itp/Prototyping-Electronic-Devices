import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int serverAddrOnThisMachine = 12000;

//send to server within this sketch

//String remoteLocationAddr = "127.0.0.1";
//int remoteLocationPort = serverAddrOnThisMachine; 

//send to server on RPI

String remoteLocationAddr = "192.168.11.64";  //change this to RPI address
int remoteLocationPort = 12000; 


void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, serverAddrOnThisMachine);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress(remoteLocationAddr, serverAddrOnThisMachine);
}


void draw() {
  background(0);
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/led");

  myMessage.add(int(random(100))); /* add an int to the osc message */
  myMessage.add(50); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

void keyPressed() {
  if (key==' ') {
    OscMessage myMessage = new OscMessage("/led2");
    myMessage.add(int(random(100)));
    myMessage.add(int(random(100)));
    oscP5.send(myMessage, myRemoteLocation);
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  if (theOscMessage.typetag().equals("ii")) {  //two ints in message
    println(theOscMessage.get(0).intValue()+" "+theOscMessage.get(1).intValue());
  }
}