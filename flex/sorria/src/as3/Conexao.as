package componentes.actionScript{
	import mx.controls.Alert;
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class Conexao{

         public static var endPointUrl:String = "http://localhost:3000/rubyamf/gateway";  
         public static var channelName:String = "rubyamf";  
   
         private function instanceRemoteObject():RemoteObject {  
             var cs:ChannelSet = new ChannelSet();   // Cria um ChannelSet.  
             var customChannel:Channel = new AMFChannel(channelName, endPointUrl);   // Cria um Channel.  
             cs.addChannel(customChannel);   // Adiciona o Channel ao ChannelSet. 
             var connection:RemoteObject = new RemoteObject(channelName);   // instância o objeto  
             connection.channelSet = cs;   // Assign the ChannelSet to a RemoteObject instance.  
   
             return connection;  
         }  
   
         /** 
         * Método que trata quando há algum erro de Conexão
         */  
         public function onConnectionFault(event:FaultEvent) : void {  
             Alert.show(event.fault.getStackTrace(),"FALHA DE CONEXÃO!");  
         }  
   
         /** 
         * 
         * @param Método da Classe 
         * @callBack Função de Retorno do Método Assincrono 
         * @VO Instancia do VO que navegará entre as camadas no back-end 
         */  
         public function call(servico:String, metodo:String, callBack:Function, VO:Object=null) : void {  
             var connection:RemoteObject = instanceRemoteObject();  // recuperando uma instância do RemoteObject pré-configurada  
   
             connection.source = servico;   // Faz a busca do serviço solicitado 
            
             connection.showBusyCursor = true;   // Mostra o cursor ocupado  
             
             connection.addEventListener(FaultEvent.FAULT, onConnectionFault);  // Mostra erros, se ocorrerem  
   
             // executa o método da classe de serviço  
             var op:Operation = connection.getOperation(metodo) as Operation;  
             op.addEventListener(ResultEvent.RESULT, callBack);  
   
             // quando houver a necessidade de enviar um objeto para o  servidor  
             if(VO==null){
             	op.send()
             }else{
             	op.send(VO);
             }
   
         }  
     }  
     
     
}