gulp = require 'gulp'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
imageResize = require 'gulp-image-resize'
imagemin = require 'gulp-imagemin'
parcel = require 'gulp-parcel'
rev = require 'gulp-rev'
revReplace = require 'gulp-rev-replace'
revDel = require 'rev-del'
sequence = require 'run-sequence'
del = require 'del'
vinylPaths = require 'vinyl-paths'

# filesInStream = require 'gulp-filesinstream'
# chalk = require 'chalk'

resizeOptions300 = {
  width : 300,
  height : 300,
  gravity : 'Center',
  crop : true,
  upscale : true,
  imageMagick : true,
}

resizeOptions200 = {
  width : 200,
  height : 200,
  gravity : 'Center',
  crop : true,
  upscale : true,
  imageMagick : true,
}

resizeOptions100 = {
  width : 100,
  height : 100,
  gravity : 'Center',
  crop : true,
  upscale : true,
  imageMagick : true,
}

imageminOptions = {
    optimizationLevel: 7
}

gulp.task 'build:sass', () ->
  gulp.src 'source/stylesheets/**/*.scss'
    .pipe sass()
    .pipe gulp.dest('build/stylesheets/')

gulp.task 'watch:sass', ['build:sass'], () ->
  gulp.watch ['source/stylesheets/**/*.scss'], ['build:sass']

gulp.task 'build:jpg', () ->
  gulp.src 'lecture/data/img/**/*.{jpg,JPG,jpeg,JPEG}'
    .pipe gulp.dest('build/images/')

gulp.task 'watch:jpg', ['build:jpg'], () ->
  gulp.watch ['lecture/data/img/**/*.{jpg,JPG,jpeg,JPEG}'], ['build:jpg']

gulp.task 'build:png', () ->
  gulp.src 'lecture/data/img/**/*.{png,PNG}'
    .pipe gulp.dest('build/images/')

gulp.task 'watch:png', ['build:png'], () ->
  gulp.watch ['lecture/data/img/**/*.{png,PNG}'], ['build:png']

gulp.task 'build:images', ['build:jpg', 'build:png']

gulp.task 'watch:images', ['watch:jpg', 'watch:png']

gulp.task 'build:pdfs', () ->
  gulp.src 'lecture/data/**/*.pdf'
    .pipe gulp.dest('build/pdfs/')

gulp.task 'watch:pdfs', ['build:pdfs'], () ->
  gulp.watch ['lecture/data/img/**/*.pdf'], ['build:pdfs']

gulp.task 'build:txts', () ->
  gulp.src 'lecture/data/**/*.txt'
    .pipe gulp.dest('build/txts/')

gulp.task 'watch:txts', ['build:txts'], () ->
  gulp.watch ['lecture/data/img/**/*.txt'], ['build:txts']

gulp.task 'build:js', () ->
  gulp.src 'source/javascripts/all.js', {read:false}
    .pipe parcel()
    .pipe gulp.dest('build/javascripts/')

gulp.task 'watch:js', () ->
  gulp.src 'source/javascripts/all.js', {read:false}
    .pipe parcel({
      watch: true
    })
    .pipe gulp.dest('build/javascripts/')

gulp.task 'build', ['build:js', 'build:sass', 'build:images'], () ->
  sequence 'rev', 'rev:clean'


gulp.task 'watch', ['watch:js', 'watch:sass', 'watch:images']

gulp.task 'rev', () ->
  gulp.src ['build/**/*.+(js|css|png|gif|jpg|jpeg|svg|woff|ico)', '!build/**/*-[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]*.+(js|css|png|gif|jpg|jpeg|svg|woff|ico)']
    .pipe rev()
    .pipe gulp.dest 'build/'
    .pipe rev.manifest('manifest.json')
    .pipe revDel({ dest: 'build/'})
    .pipe gulp.dest('build/')

gulp.task 'rev:replace', () ->
  manifest = gulp.src 'build/manifest.json'
  gulp.src 'build/**/*.+(html|css|js)'
    .pipe revReplace(manifest: manifest)
    .pipe gulp.dest('build/')

gulp.task 'rev:clean', () ->
  gulp.src ['build/**/*.+(js|css|png|gif|jpg|jpeg|svg|woff|ico)', '!build/**/*-[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]*.+(js|css|png|gif|jpg|jpeg|svg|woff|ico)']
    .pipe(vinylPaths(del))

gulp.task 'post', ['rev:replace']