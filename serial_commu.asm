		LIST	 p=16F877a	    		
		include "P16F877a.inc"  		
	
		 cblock 0x20					
         LCDdata ,CMDreg,K,J
         endc
	
 		Inchar 	  EQU 	021 	

		org		0x00		    					
		goto	start					 
	    org		0x20						
 start  						    		

		banksel TRISD  					
		clrf 	TRISD 					
		movlw	B'10000000'
		movwf	TRISC					
		
										
		bcf 	TXSTA,TX9				
		bcf 	TXSTA,TXEN 				 
		bcf		TXSTA,SYNC 				
		bsf		TXSTA,BRGH 				

										
		movlw	D'25'  					
		movwf 	SPBRG 					

		bsf		TXSTA,TXEN 				
										
		banksel RCSTA  					
		bsf		RCSTA,SPEN 				

		movlw   0x80 		   			
		call 	sendCMD							
		call    Delay					 
		call	Delay					
		
USART	call	ReadVT					
		call    SendtoLCD
		goto 	USART 					
loop	goto	loop
  
ReadVT
	    bsf 	RCSTA,CREN 				
wait1   btfss  	PIR1,RCIF 		 
		goto	wait1 				
		movf	RCREG,W 				
		movwf	Inchar 					
		movlw   0x30 					
		subwf   Inchar,W 				
		return						
  
SendtoLCD
		addlw 0x30 
		movwf	 TXREG  				
wait2 	btfss	 PIR1,TXIF 				
 		goto	 wait2					
 		return							
sendCMD	movwf 	CMDreg    	  			    
	   	movlw	0xFE         			
	   	call 	SendtoLCD
	   	movf 	CMDreg,W	          	
	   	goto 	SendtoLCD
               

Delay	bcf 	STATUS, RP1				
		bcf 	STATUS, RP0	
		movlw 	d'250'			
		movwf 	J
Jloop:	movwf 	K
Kloop:	decfsz 	K,f
		goto 	Kloop
		decfsz 	J,f
		goto 	Jloop
		return

end