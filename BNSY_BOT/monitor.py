import time
import psutil
import oracledb
import subprocess
import socket
import os

# ==========================================
# [설정] 환경변수 로드 (없으면 기본값 사용)
# ==========================================
TARGET_IP = os.environ.get('BACK_PATH')
DB_USER   = os.environ.get('DB_USER')
DB_PASS   = os.environ.get('DB_PASS')

# DB 접속 정보 구성
DB_DSN = f"{TARGET_IP}:1521/xe"

def get_server_ip():
    """현재 서버의 IP 주소 가져오기"""
    try:
        return socket.gethostbyname(socket.gethostname())
    except:
        return "127.0.0.1"

def get_gpu_usage():
    """nvidia-smi를 통해 GPU 사용률 가져오기"""
    try:
        # Windows 환경 shell=True 추가
        result = subprocess.run(['nvidia-smi', '--query-gpu=utilization.gpu', '--format=csv,noheader,nounits'], 
                                capture_output=True, text=True, shell=True)
        if result.returncode == 0:
            return float(result.stdout.strip())
        else:
            return 0.0
    except:
        return 0.0

def collect_metrics():
    conn = None
    server_ip = get_server_ip()
    
    try:
        conn = oracledb.connect(user=DB_USER, password=DB_PASS, dsn=DB_DSN)
        cursor = conn.cursor()
        
        print(f"🚀 시스템 모니터링 시작 (Server IP: {server_ip})")
        print(f"   Target DB: {DB_DSN}")
        print("   [Ctrl+C]를 눌러 종료하세요.")
        
        while True:
            # 1. 시스템 정보 수집
            cpu = psutil.cpu_percent(interval=None) 
            mem = psutil.virtual_memory().percent
            gpu = get_gpu_usage()
            
            # 상태 결정 로직
            status = 'NORMAL'
            if cpu > 90 or mem > 90:
                status = 'WARNING'
            
            # 2. DB 저장
            sql = """
                INSERT INTO SERVER_METRIC 
                (SERVER_IP, CPU_USAGE, MEM_USAGE, GPU_USAGE, RPM, LATENCY, STATUS, LOG_DT) 
                VALUES (:1, :2, :3, :4, 0, 0, :5, SYSTIMESTAMP)
            """
            cursor.execute(sql, (server_ip, cpu, mem, gpu, status))
            conn.commit()
            
            time.sleep(3)
            
    except Exception as e:
        print(f"❌ 오류 발생: {e}")
    finally:
        if conn: conn.close()

if __name__ == "__main__":
    psutil.cpu_percent()
    collect_metrics()