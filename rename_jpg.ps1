function renameJpeg() {
    # 実行前ファイルリストログ出力
    $list = Get-ChildItem -Path ($path + '\inputs') -File -Filter *.jpeg | Select-Object FullName
    Out-File ($path + "\inList_jpeg_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Encoding default -Append -InputObject $list

    # ファイル一覧取得
    $item = Get-ChildItem -Path ($path + '\inputs') -Name -Include *.jpeg

    # 出力フォルダ作成
    if(!(Test-Path ($path + "\outputs\jpeg"))) {
        mkdir ($path + "\outputs\jpeg")
    }

    #cd $path
    foreach($f in $item) {
        # 日付データをプロパティから取得
        $fi = $folder.ParseName($f)
        $propUpdate = $folder.GetDetailsOf($fi,$propUpdateNum)
        $propTake = $folder.GetDetailsOf($fi,$propTakeNum)
        
        # 取得データをファイル名用にフォーマット(yyyy-mm-dd_hhmm)
        $propUpdate = $propUpdate -replace "/", "-" -replace "\s", "_" -replace ":", ""
        $propTake = $propTake -replace "/", "-" -replace "\s", "_" -replace ":", ""

        ################# ファイルプロパティ(tag)確認用テキスト出力 #################
        #for($p = 1; $p -le 300; $p++){
        #    $prop = $folder.GetDetailsOf($fi,$p)
        #    $out = "\propList.txt"
        #    Out-File ($path + $out) -Encoding default -Append -InputObject ($p.ToString() + ":" + $prop.ToString()).ToString()
        #}
        ###########################################################################

        # 設定データ判定
        if($propTake -ne "") {
            $propData = $propTake
        } elseif($propUpdate -ne "") {
            $propData = $propUpdate
        }

        # ファイル名に反映
        [int] $seq = 2
        # 未取得チェック
        if($propData -ne "") {
            $fPath = ($path + "\outputs\jpeg\" + $propData).toString()
            $fCur = $path + "\inputs\" + $f
            try {
                # 同一ファイル名存在チェック
                if(!(Test-Path ($fPath + ".jpeg"))) {
                    mv $fCur ($fPath + ".jpeg")
                } else {
                    # 存在していた場合は、存在しない番号まで連番を探す
                    while (Test-Path ($fPath + "_" + $seq.toString() + ".jpeg")) {
                        $seq++
                    }
                    mv $fCur ($fPath + "_" + $seq.toString() + ".jpeg")
                }
            } catch {
                $Error[$e] | Out-File ($path + "\errorList_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Append
                $e++
            }
        }
    }

    # 実行後ファイルリストログ出力
    $list = Get-ChildItem -Path ($path + '\outputs\jpeg') -File | Select-Object FullName
    Out-File ($path + "\outList_jpeg_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Encoding default -Append -InputObject $list
}

function renameJpg() {
    # 実行前ファイルリストログ出力
    $list = Get-ChildItem -Path ($path + '\inputs') -File -Filter *.jpg | Select-Object FullName
    Out-File ($path + "\inList_jpg_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Encoding default -Append -InputObject $list

    # ファイル一覧取得
    $item = Get-ChildItem -Path ($path + '\inputs') -Name -Include *.jpg

    # 出力フォルダ作成
    if(!(Test-Path ($path + "\outputs\jpg"))) {
        mkdir ($path + "\outputs\jpg")
    }

    #cd $path
    foreach($f in $item) {
        # 日付データをプロパティから取得
        $fi = $folder.ParseName($f)
        $propUpdate = $folder.GetDetailsOf($fi,$propUpdateNum)
        $propTake = $folder.GetDetailsOf($fi,$propTakeNum)
        
        # 取得データをファイル名用にフォーマット(yyyy-mm-dd_hhmm)
        $propUpdate = $propUpdate -replace "/", "-" -replace "\s", "_" -replace ":", ""
        $propTake = $propTake -replace "/", "-" -replace "\s", "_" -replace ":", ""

        # 設定データ判定
        if($propTake -ne "") {
            $propData = $propTake
        } elseif($propUpdate -ne "") {
            $propData = $propUpdate
        }

        # ファイル名に反映
        [int] $seq = 2
        # 未取得チェック
        if($propData -ne "") {
            $fPath = ($path + "\outputs\jpg\" + $propData).toString()
            $fCur = $path + "\inputs\" + $f
            try {
                # 同一ファイル名存在チェック
                if(!(Test-Path ($fPath + ".jpg"))) {
                    mv $fCur ($fPath + ".jpg")
                } else {
                    # 存在していた場合は、存在しない番号まで連番を探す
                    while (Test-Path ($fPath + "_" + $seq.toString() + ".jpg")) {
                        $seq++
                    }
                    mv $fCur ($fPath + "_" + $seq.toString() + ".jpg")
                }
            } catch {
                $Error[$e] | Out-File ($path + "\errorList_" + ((Get-Date).ToString("yyyyMMdd")) + ".log") -Append
                $e++
            }
        }
    }

    # 実行後ファイルリストログ出力
    $list = Get-ChildItem -Path ($path + '\outputs\jpg') -File | Select-Object FullName
    Out-File ($path + "\outList_jpg_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Encoding default -Append -InputObject $list
}

# ファイルパス
$path = Split-Path $MyInvocation.MyCommand.Path

# エラー番号初期化
$e = 0

# 取得プロパティ番号
[int] $propUpdateNum = 3
[int] $propTakeNum = 12

# Shellオブジェクトを生成し、実行フォルダをNameSpaceオブジェクトに変換
$sh = New-Object -ComObject Shell.Application
$folder = $sh.NameSpace($path + '\inputs')

# 出力フォルダ作成
if(!(Test-Path ($path + "\outputs"))) {
    mkdir ($path + "\outputs")
}

renameJpeg
renameJpg