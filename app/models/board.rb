class Board < ActiveRecord::Base
    resourcify # 이 아이가 있어야 권한에 따른 제어가 가능함
    belongs_to :user
end
