require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:notes).dependent(:destroy) }
  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  # たくさんのメモが付いていること
  it 'can hav many notes' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # 締切日が過ぎていれば遅延していること
  it 'is late when the due date is past today' do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  # 締切日が今日ならスケジュールどおりであること
  it 'is no time when the due date is today' do
    project = FactoryBot.create(:project, :due_today)
    expect(project).not_to be_late
  end

  # 締切日が未来ならスケジュールどおりであること
  it 'is no time when the due date is feature' do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).not_to be_late
  end

  # ユーザー単位では重複したプロジェクトを許可しないこと
  it 'dose not allow duplicate project names per user' do
    user = FactoryBot.create(:user)

    user.projects.create(
      name: 'Test Project'
    )

    new_project = user.projects.build(
      name: 'Test Project'
    )
    new_project.valid?

    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it 'allows two users to share a project name' do
    user = FactoryBot.create(:user, email: 'joetester@example.com')

    user.projects.create(
      name: 'Test Project'
    )

    other_user = FactoryBot.create(:user,email: 'janetester@example.com')

    other_project = other_user.projects.create(
      name: 'Test Project'
    )

    expect(other_project).to be_valid
  end
end
