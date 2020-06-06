<%@ WebHandler Language="C#" Class="imageUploader" %>

using System;
using System.Web;
using System.IO;

// 파일만 업로드 하고 DB로 따로 관리하지 않는 기초적이 코딩 -> 실제로는 DB상으로 파일 관리를 해줘야함
public class imageUploader : IHttpHandler,System.Web.SessionState.IRequiresSessionState {

    public void ProcessRequest (HttpContext context) {
        // <html> 같은 태그들 전부 제거
        context.Response.ContentType = "text/plain";

        try
        {
            //상대적인 저장 위치 지정
            string saveDir = @"\Upload\";
            // 실제 저장 path 구해오기
            string dirFullPath = HttpContext.Current.Server.MapPath(saveDir);
            // 실제저장 위치에 폴더 생성
            Directory.CreateDirectory(dirFullPath);


            string[] files;
            int numFiles;
            files = System.IO.Directory.GetFiles(dirFullPath);
            // 파일 이름 중복 제거 -> 사진_1 사진_2 , 이런 방식 말고 UUID로 관리하는게 좋음
            numFiles = files.Length;
            numFiles = numFiles + 1;
            string str_image = "";

            // 파일 리스트를 이름으로 순환
            foreach (string s in context.Request.Files)
            {
                //각 파일 명으로 파일 객체를 가져옴
                HttpPostedFile file = context.Request.Files[s];
                //가져온 파일의 이름
                string fileName = file.FileName;
                //가져온 파일의 확장자 .jpg .png...
                string fileExtension = file.ContentType;
                // 가져온 파일 명이 비어있거나 null 이 아닐경우에만 동작
                if (!string.IsNullOrEmpty(fileName))
                {
                    // 파일 저장 이름, 확장자 지정
                    fileExtension = Path.GetExtension(fileName);
                    str_image = fileName + numFiles.ToString() + fileExtension;
                    // 파일 저장
                    file.SaveAs(dirFullPath+str_image);
                }
            }
            //  database record update logic here  ()


            // http 응답으로 파일 명을 돌려줌 -> JSON 형식으로 돌려주도록 변경하는것이 좋음
            context.Response.Write(saveDir+str_image);
        }
        catch (Exception ac)
        {

        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}