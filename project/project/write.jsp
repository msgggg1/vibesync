<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            box-sizing: border-box;
        }
        #summernote {
            margin-bottom: 10px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .note-editable img {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        .note-popover {
            display: none !important;
        }
    </style>
</head>
<body>
    <h1>글 작성</h1>
    <form action="save.jsp" method="post">
        <input type="text" name="title" placeholder="제목" required>
        <textarea id="summernote" name="content"></textarea>
        <input type="submit" value="저장">
    </form>
    <script>
        $(document).ready(function() {
            $('#summernote').summernote({
                height: 300,
                tooltip: false,
                callbacks: {
                    onImageUpload: function(files) {
                        var formData = new FormData();
                        formData.append('file', files[0]);
                        $.ajax({
                            url: 'upload.jsp',
                            method: 'POST',
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: function(url) {
                                var img = $('<img>').attr('src', url).css({
                                    'display': 'block',
                                    'margin-left': 'auto',
                                    'margin-right': 'auto'
                                });
                                $('#summernote').summernote('insertNode', img[0]);
                            },
                            error: function() {
                                alert('이미지 업로드 실패');
                            }
                        });
                    }
                }
            });
        });
    </script>
</body>
</html>