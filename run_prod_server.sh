#!/bin/bash

# 로그 파일 초기화
echo "서버 로그 시작" > server.log

# pylint 검사
echo "** pylint 검사 시작 **" >> server.log
pylint --rcfile .pylintrc src/ >> server.log 2>&1
if [ $? -ne 0 ]; then
  echo "pylint 검사에 실패했습니다. 서버 시작을 중단합니다." >> server.log
  exit 1
fi
echo "** pylint 검사 종료 **" >> server.log

# mypy 타입 검사
echo "** mypy 타입 검사 시작 **" >> server.log
mypy src/ >> server.log 2>&1
if [ $? -ne 0 ]; then
  echo "mypy 타입 검사에 실패했습니다. 서버 시작을 중단합니다." >> server.log
  exit 1
fi
echo "** mypy 타입 검사 종료 **" >> server.log

# uvicorn 실행
echo "** uvicorn 서버 실행 시작 **" >> server.log
uvicorn main:app --host 0.0.0.0 --port 8000 >> server.log 2>&1
if [ $? -ne 0 ]; then
  echo "uvicorn 서버 실행에 실패했습니다. 다시 시도해주세요." >> server.log
  exit 1
fi
echo "** uvicorn 서버 실행 종료 **" >> server.log

echo "코드 검사 및 서버 실행이 성공적으로 완료되었습니다." >> server.log
