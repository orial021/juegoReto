from fastapi import  Request, status, HTTPException
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
import traceback
import logging
from models.error_log import ErrorLog

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

class HTTPErrorHandler(BaseHTTPMiddleware):  
    async def dispatch(self, request: Request, call_next):
        try:
            logger.info(f"Procesando: {request.method} {request.url} {request.client.host}")
            return await call_next(request)
        except HTTPException as http_exc:
            logger.error("HTTPException capturada", exc_info=True)
            username = getattr(request.state, 'user', {}).get('username', None)
            error_info = {
                'error_type': 'HTTPException',
                'message': http_exc.detail,
                'traceback': traceback.format_exc()[35:],
                'url': str(request.url),
                'status_code': http_exc.status_code,
                'username': username,
                'method': request.method,
                'headers': dict(request.headers)
            }
            await ErrorLog.create(**error_info)
            return JSONResponse(content = {'detail' : http_exc.detail},
                                status_code = http_exc.status_code)
        except Exception as e:
            logger.error("Excepcion general capturada", exc_info=True)
            username = getattr(request.state, 'user', {}).get('username', None)
            error_info = {
                'error_type': 'Exception',
                'message': str(e),
                'traceback': traceback.format_exc()[35:],
                'url': str(request.url), 
                'status_code': status.HTTP_500_INTERNAL_SERVER_ERROR,
                'username': username,
                'method': request.method,
                'headers': dict(request.headers),
            }
            await ErrorLog.create(**error_info)
            
            return JSONResponse(content = {'detail' : 'Internal Server Error'},
                                status_code = status.HTTP_500_INTERNAL_SERVER_ERROR)