#DEFINE CRLF chr(13)+chr(10)
#DEFINE LF chr(10)
#DEFINE cTitulo 		"Ingresos/Salidas "
#DEFINE cTituloNF 		"Legalizacion Despacho Salida"
#DEFINE cPNGBAR 		"||!!|!||||¡¡¡!|!!!¡||||||||"
#DEFINE cPNGLEGAL 		"LEYENDA"
#DEFINE AMARILLO 		"BR_AMARELO_OCEAN.PNG"
#DEFINE ROJO 			"BR_VERMELHO.PNG"
#DEFINE VERDE 			"BR_VERDE_OCEAN.PNG"   				
#DEFINE GRIS  			"BR_CINZA.PNG"   
#DEFINE NEGRO 			"BR_PRETO.PNG"
#DEFINE MARRON 			"BR_MARROM.PNG"
#DEFINE BLANCO 			"BR_BRANCO.PNG"
#DEFINE AZUL 			"BR_AZUL_OCEAN.PNG"
#DEFINE ROSA			"BR_PINK.PNG"	
#DEFINE NARANJA			"BR_LARANJA"
#DEFINE VERDE_C			"VERDE_OSCURO.PNG"

#DEFINE ESTADO_BLANCO	"1"  // cEstado1	:= '1' // Nuevo, Salida de Materia sin Ingreso aun						"ZX2_ESTADO = '1'",BLANCO 	, "Salida Almacen"
#DEFINE ESTADO_ROJO		"2"  // cEstado2	:= '2' // Ingreso, entrada de Materia, Entrada  Invalida SOBRA			"ZX2_ESTADO = '2'",ROJO		, "Entrada Invalida"
#DEFINE ESTADO_NARANJA	"3"  // cEstado3	:= '3' // Ingreso, entrada de Materia, Entrada, Faltan  Amarillo,     	"ZX2_ESTADO = '3'",NARANJA	, "Espera por Legalizar (Parcial)" 
#DEFINE ESTADO_AMARILLO	"4"  // cEstado3	:= '4' // Ingreso, entrada de Materia, Entrada  completa verde TIPO		"ZX2_ESTADO = '4'",AMARILLO	, "Espera por Legalizar (Parcial)" 
#DEFINE ESTADO_AZUL		"5"  // cEstado4	:= '5' // Ingreso, entrada de Materia, Legalizada Parcailmente			"ZX2_ESTADO = '5'",AZUL		, "Parcialmente Legalizada"
#DEFINE ESTADO_VERDE	"6"  // cEstado5	:= '6' // Legalizada Verde												"ZX2_ESTADO = '6'",VERDE	, "Legalizada"		
#DEFINE ESTADO_VERDEC	"7"  // cEstado5	:= '6' // Legalizada Verde	

#DEFINE TP_MOV_GRIS		"1"	 // Nueva Salida de Material
#DEFINE TP_MOV_VERDE	"2"	 // Salida y entrada de materia Cohinciden
#DEFINE TP_MOV_AMARILLO	"3"	 // La cantidad de Salida de Materia es Superior a la entrada
#DEFINE TP_MOV_ROJO		"4"  // La cantidad de Materia de Entrada es superrio a la de Salida


#DEFINE EstadoVERDE  	"Documento Ingreso"
#DEFINE EstadoROJO		"Documento Salida"
#DEFINE EstadoBLANCO	"Documento Legalizado" 

#DEFINE STR001 "Movimientos Pistoleo Acme"
#DEFINE STR002 "Visualizar" 
#DEFINE STR003 "Incluir"    
#DEFINE STR004 "Alterar"     
#DEFINE STR005 "Reversión"    
#DEFINE STR006 "Imprimir"  
#DEFINE STR007 "Copiar"    
#DEFINE STR008 "Modelo de dados de Entrada/Salida"
#DEFINE STR009 "Dados de Entrada/Salida"
#DEFINE STR010 "Movimientos multiples Acme Leon"
#DEFINE STR011 "Encabezado Movimiento"
#DEFINE STR012 "Detalles del Movimiento"
#DEFINE STR013 "Encabezado Movimiento Interno"
#DEFINE STR014 "Detalles del Movimiento"
#DEFINE STR015 "Procesando los Códigos"
#DEFINE STR016 "Leyendo los registros y sumando, espere..."
#DEFINE STR017 "¿Subir los códigos al sistema?"
#DEFINE STR018 "Agregando..."
#DEFINE STR019 "Sumando..."
#DEFINE STR020 "No se realizó la transferencia de Códigos"
#DEFINE STR021 "No se encontraron datos"
#DEFINE STR023 "Lectura de Códigos de Barra"
#DEFINE STR024 "Procesar"
#DEFINE STR025 "Cancelar"
#DEFINE STR026 "Uno de los campos del encabezado no está diligenciado."+chr(13)+chr(10)+"Favor revise, Cod Movimiento/Número de documento y Almacen"
#DEFINE STR027 "Completar encabezado"
#DEFINE STR028 "Saldo Insuficiente"
#DEFINE STR029 "La cantidad de productos de salida supera la existencia en Inventario"
#DEFINE STR030 "Revise las cantidades de:<br>"
#DEFINE STR031 "Intente y anote"
#DEFINE STR032 "Error al ejecutar Exeacuto"
#DEFINE STR033 "Reintente la operacion y copie el mensaje"
#DEFINE MODEL_OPERATION_IMPRESION   8
#DEFINE MODEL_OPERATION_COPIAR      9
#DEFINE MODEL_OPERATION_REVERSION   6 
