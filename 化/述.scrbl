#lang scribble/manual
@require[@for-label[racket]]

@title{語}
@author{zaoqi}

@defmodule[lang #:lang #:packages ("lang")]

@define-syntax-rule[(重名詞法 名 原) @define-syntax-rule[(名 . 參) (原 . 參)]]

@重名詞法[述化 defproc]
@重名詞法[語 racket]
@重名詞法[述 defform]
@重名詞法[述/子 defform/subs]
@重名詞法[述值 defthing]

@section{形式}
@述[(#%式 式 甲 ...)]{等價與使用@語[化.用]和@語[→式-1]。使用一個@語[:式？]@語[式]。可以寫作@語[{式 甲 ...}]。}
@述[(#%頂 名)]{頂層的物。}
@述[(化 形 ...)]{等價與使用@語[化.用]。}

@section{物}
@subsection{結構/值}
@subsubsection{化}
@語[(→化 '<形> '((#%頂 <名>) . <形>))]

@subsection{述}
@述化[(等？ [甲 (非 :誤？)] [乙 (非 :誤？)]) :陰-陽？]{返回@語[甲]是否等於@語[乙]。}
@述化[(算 [物 :物？] [集/定 :集/定？]) :物？]
@述化[(取 [:名 名？]) :物？]{獲取一個包}
@述化[(或 [甲 :物？] [乙 :物？]) :物？]{一般是@語[甲]，可以是@語[乙]。}

@subsubsection{陰-陽}
@述值[:陰-陽/陰 :陰-陽？]
@述值[:陰-陽/陽 :陰-陽？]
@述化[(陰陽.若 [:物 陰-陽？] [甲 :物？] [乙 :物？]) :物？]{若@語[:陰-陽/陽]是@語[陽]，則返回@語[乙]，否則返回@語[丙]。}

@subsubsection{列}
@述化[(:列/構？ [:物 (非 :誤？)]) :陰-陽？]
@述化[(→列/構 [首 :物？] [尾 :物？]) :列/構？]
@述化[(列/構.首 [:物 :列/構？]) :物？]
@述化[(列/構.尾 [:物 :列/構？]) :物？]
@述值[:列/空 列/空？ #:value ()]

@subsubsection{名}
@述化[(:名/文？ [:物 (非 :誤？)]) :陰-陽？]

@述化[(:名/構？ [:物 (非 :誤？)]) :陰-陽？]
@述化[(→名/構 [:名 :物？] [:列 :物？]) :名/構？]{@語[:名]一般是@語[:名]。@語[:列]一般是@語[:列]。}
@述化[(名/構.:名 [:物 :名/構？]) :物？]
@述化[(名/構.:列 [:物 :名/構？]) :物？]

@subsubsection{集/定}
@述化[(:集/定？ [:物 (非 :誤？)]) :陰-陽？]
@述值[空:集/定 :集/定？]
@述化[(集/定.增 [:物 :集/定？] [名 :物？] [甲 :物？]) :集/定？]{原來沒有，是增。}
@述化[(集/定.改 [:物 :集/定？] [名 :物？] [:化 (-> :物？ :物？)]) :集/定？]
@述化[(集/定.取 [:物 :集/定？] [名 :物？]) :物？]
@述化[(集/定.含？ [:物 :集/定？] [名 :物？]) :陰-陽？]
@述化[(集/定.删 [:物 :集/定？] [名 :物？]) :集/定？]{必須有，才能刪。}
@述化[(集/定→列 [:物 :集/定？]) (listof (list/c any/c any/c))]

@subsubsection{化}
@述化[(:化？ [:物 (非 :誤？)]) :陰-陽？]
@述化[(→化 [形 :物？] [:物 :物？]) :化？]{@語[形]類似Scheme,不是@語[:列]的當成@racket[symbol?]。}
@述化[(化.形 [:物 :化？]) :物？]
@述化[(化.物 [:物 :化？]) :物？]
@述化[(化.用 [:物 :化？] [形 :物？]) :物？]{如果@語[形]和@語[:物]不能匹配，這個@語[:誤]是@語[形]產生的。}

@subsubsection{式}
@述化[(:式？ [:物 (非 :誤？)]) :陰-陽？]
@述化[(→式 [:化 :物？]) :式？]{@語[化]一般是@語[(-> :集/定？ :物？ ... :物？)]。}
@述化[(→式-1 [:物 :式？]) :物？]

@subsubsection{構}
@述化[(:構？ [:物 (非 :誤？)]) :陰-陽？]
@述化[(→構 [:名 :物？] [:列 :物？]) :構？]{@語[:名]一般是@語[:名]，@語[:列]一般是@語[:列]。}
@述化[(構.:名 [:物 :構？]) :物？]
@述化[(構.:列 [:物 :構？]) :物？]

@subsubsection{誤}
@述化[(:誤？ [:物 :物？]) :陰-陽？]
@述化[(→誤 [:物 :物？]) :誤？]
@述化[(→誤-1 [:物 :誤？]) :物？]

@section{誤}
@subsection{無}
替換：在進行0或更多次替換後，可以把沒有結果（需要無限的時間的）的任意個@語[:物]替換爲@語[(→誤 (→構 {引 誤/界/無} <未定義>))]，@語[<未定義>]是任意的@語[:物]。

實現應該儘量避免無限的運行下去。

實現應該儘量避免無用的替換。
@subsection{化}
內置的任何@語[:化]產生的@語[:誤]是@語[(→誤 (->:構 {引 誤/界/化} ((→化 '(:列) ':列) <:名> <式> <位:名>)))]，
@語[<:名>]是它的名稱，@語[<式>]是它的參數，@語[<位:名>]是產生@語[:誤]的參數的名稱。

@section{類Racket語法}
每個vector和symbol會被轉換爲一個@語[:名]。

WIP
