import chainlit as cl
from tools import logger
from chatbot.chatclass import Text2SQL

# Variable global para el chatbot
chatbot = None

@cl.on_chat_start
async def on_chat_start():
    """
    Se ejecuta cuando inicia una nueva conversación
    """
    global chatbot
    chatbot = Text2SQL()
    logger.info("Nueva conversación iniciada - Chatbot reiniciado")
    
    # Mensaje de bienvenida
    welcome_message = """¡Hola! 👋 Soy tu asistente para la base de datos de **Popau Elements**.

🎯 **Mi función:** Convertir tus preguntas en lenguaje natural a consultas SQL y ejecutarlas en nuestra base de datos.

📊 **Qué puedo hacer:**
- Responder preguntas sobre datos.
- Generar reportes y estadísticas
- Buscar información específica
- Crear consultas SQL precisas

¡Pregúntame lo que necesites saber de la base de datos! 🚀"""

    await cl.Message(content=welcome_message).send()
    

@cl.on_message
async def on_message(message: cl.Message):
    global chatbot
    
    # Verificar que el chatbot esté inicializado
    if chatbot is None:
        chatbot = Text2SQL()
    
    msg = cl.Message(content='')
    response = ''

    async with cl.Step(type='run'):
        for chunk in chatbot.main(prompt=message.content):
            await msg.stream_token(chunk)
            response += chunk

        await msg.send()

    logger.info(response)

@cl.on_chat_end
async def on_chat_end():
    """
    Se ejecuta cuando termina una conversación
    """
    global chatbot
    logger.info("Conversación terminada")
    chatbot = None
