export current_user=$USER
export current_time=$(date "+%Y-%m-%d %H:%M:%S")
export message="$current_user $current_time Commit StoryBoard"

export file_to_commit=../src/TokyoMetro/TokyoMetro/Base.lproj/Main.storyboard

svn commit $file_to_commit -m "$message"
