# アーキテクチャについて
## 選択したアーキテクチャ
- MVVM
- Repository
## MVVM 選択理由
- SwiftUIを利用したプロジェクトにおける親和性
- Viewとロジック部分の関心を分離させることで、変更に強いプロジェクトになると考えた。

## Repository パターン選択理由
- MVVMのViewModel がどこからデータを取得・更新するのかを意識させないために
ビジネスロジックとデータ操作を分離することを目的としています。
- また、Mockと差し替えることでテストを可能にし、開発のスピードも上がると考えた。
