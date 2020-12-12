
alias StakeLaneApi.Repo

alias StakeLaneApi.Finances.Plan

Repo.insert %Plan { name: :free, price: %Money{amount: 0, currency: :USD}}

Repo.insert %Plan { name: :number_one_fan, price: %Money{amount: 1_50, currency: :USD}}
Repo.insert %Plan { name: :number_one_fan, price: %Money{amount: 1_50, currency: :EUR}}
Repo.insert %Plan { name: :number_one_fan, price: %Money{amount: 1_50, currency: :GBP}}
Repo.insert %Plan { name: :number_one_fan, price: %Money{amount: 5_00, currency: :BRL}}
Repo.insert %Plan { name: :number_one_fan, price: %Money{amount: 50_00, currency: :MXN}}

Repo.insert %Plan { name: :four_four_two, price: %Money{amount: 3_00, currency: :USD}}
Repo.insert %Plan { name: :four_four_two, price: %Money{amount: 3_00, currency: :EUR}}
Repo.insert %Plan { name: :four_four_two, price: %Money{amount: 3_00, currency: :GBP}}
Repo.insert %Plan { name: :four_four_two, price: %Money{amount: 8_00, currency: :BRL}}
Repo.insert %Plan { name: :four_four_two, price: %Money{amount: 80_00, currency: :MXN}}

Repo.insert %Plan { name: :stake_horse, price: %Money{amount: 5_00, currency: :USD}}
Repo.insert %Plan { name: :stake_horse, price: %Money{amount: 5_00, currency: :EUR}}
Repo.insert %Plan { name: :stake_horse, price: %Money{amount: 5_00, currency: :GBP}}
Repo.insert %Plan { name: :stake_horse, price: %Money{amount: 10_00, currency: :BRL}}
Repo.insert %Plan { name: :stake_horse, price: %Money{amount: 100_00, currency: :MXN}}

Repo.insert %Plan { name: :top_brass, price: %Money{amount: 0, currency: :USD}}
