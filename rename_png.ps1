# ファイルパス
$path = Split-Path $MyInvocation.MyCommand.Path

# エラー番号初期化
$e = 0

# 出力フォルダ作成
if(!(Test-Path ($path + "\outputs"))) {
    mkdir ($path + "\outputs")
}
if(!(Test-Path ($path + "\outputs\png"))) {
    mkdir ($path + "\outputs\png")
}

# ファイル名称パターン
# パターンが異なる物がある場合はaddで正規表現パターンを追加する
$nameRegArr = New-Object System.Collections.ArrayList
$nameRegArr.Add("Screenshot_(\d{8})-(\d{6})\.png")
[int]$i = 0

# Shellオブジェクトを生成し、実行フォルダをNameSpaceオブジェクトに変換
$sh = New-Object -ComObject Shell.Application
$folder = $sh.NameSpace($path + '\inputs')

foreach($reg in $nameRegArr) {
    # 実行前ファイルリストログ出力
    $list = Get-ChildItem -Path ($path + '\inputs') -File | Where{$_.Name -Match $reg} | Select-Object FullName
    Out-File ($path + "\inList_png" + $i.ToString() + "_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Encoding default -Append -InputObject $list

    # ファイル一覧取得
    $item = Get-ChildItem -Path ($path + '\inputs') -Name | Select-String $reg

    foreach($f in $item) {
        # 現在のファイル名からリネーム用ファイル名の情報を取得
        $nameData = [regex]::Replace($f, $reg, {$args.groups[1].value + $args.groups[2].value})

        # 取得データをファイル名用にフォーマット(yyyy-mm-dd_hhmm)
        $fName = $nameData.Substring(0, 4) + "-" + $nameData.Substring(4, 2) + "-" + $nameData.Substring(6, 2) + "_" + $nameData.Substring(8, 4)

        # ファイル名に反映
        [int] $seq = 2
        # 未取得チェック
        if($fName -ne "") {
            $fPath = ($path + "\outputs\png\" + $fName).toString()
            $fCur = $path + "\inputs\" + $f
            try {
                # 同一ファイル名存在チェック
                if(!(Test-Path ($fPath + ".png"))) {
                    mv $fCur ($fPath + ".png")
                } else {
                    # 存在していた場合は、存在しない番号まで連番を探す
                    while (Test-Path ($fPath + "_" + $seq.toString() + ".png")) {
                        $seq++
                    }
                    mv $fCur ($fPath + "_" + $seq.toString() + ".png")
                }
            } catch {
                $Error[$e] | Out-File ($path + "\errorList_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Append
                $e++
            }
        }
    }
}
# 実行後ファイルリストログ出力
$list = Get-ChildItem -Path ($path + '\outputs\png') -File | Select-Object FullName
Out-File ($path + "\outList_png_" + ((Get-Date).ToString("yyyyMMdd-HHmmss")) + ".log") -Encoding default -Append -InputObject $list


