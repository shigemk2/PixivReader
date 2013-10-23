# -*- coding: utf-8 -*-
class PixivViewController < UITableViewController
  def viewDidLoad
    super

    @feed = nil
    @items = []
    self.navigationItem.title = "Pixiv ManaRitsu Reader"
    self.view.backgroundColor = UIColor.whiteColor

    self.getItems(@feed)
    self.buildRefreshBtn
  end

  def getItems(feed)
    url = "http://spapi.pixiv.net/iphone/search.php?s_mode=s_tag&word=%E3%83%9E%E3%83%8A%E3%82%8A%E3%81%A4&PHPSESSID=0"
    BW::HTTP.get(url) do |response|
      if response.ok?
        @feed = response.body.to_str
        lines = @feed.split("\n")
        for row in lines
          @items << row.split(",")
          view.reloadData
        end
      else
        App.alert(response.error_message)
      end
    end

    return @items
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if @items.nil?
      return 0
    else
      # @items.size
      15
    end
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    40
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('cell') || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'cell')
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    if @items == []
      return cell
    end

    # user
    cell.textLabel.frame = CGRectMake(200, 200, 20, 30)
    cell.textLabel.text = @items[indexPath.row][5].gsub(/\"/, "")
    cell.textLabel.font = UIFont.boldSystemFontOfSize(14)
    cell.textLabel.textAlignment = UITextAlignmentRight

    # thumbnail
    image_path = @items[indexPath.row][6].gsub(/\"/, "")
    image_src = NSData.dataWithContentsOfURL(NSURL.URLWithString(image_path))
    image = UIImage.imageWithData(image_src)

    image_view = UIImageView.alloc.initWithImage(image)
    image_view.frame = CGRectMake(5, 5, 30, 30)
    cell.addSubview(image_view)
    return cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    WebViewController.new.tap do |c|
      c.item = @items[indexPath.row]
      self.navigationController.pushViewController(c, animated:true)
    end
  end

  # 更新ボタンを生成
  def buildRefreshBtn
    btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                            target:self,
                                                            action:"eventRefreshBtn:")
    btn.tintColor = UIColor.redColor
    self.setToolbarItems(arrayWithObjects:"btn", animated:true)
    self.navigationItem.leftBarButtonItem = btn
  end

  # 処理中のイベント
  def eventActivityIndicator
    self.getItems(@feed)

    # 処理中を、更新ボタンに切り替える
    self.buildRefreshBtn
  end

  # 更新ボタンのイベント
  def eventRefreshBtn(sender)
    # 更新ボタンを、処理中に切り替える
    self.buildActivityIndicator
  end

  # 処理中を生成
  def buildActivityIndicator
    activityIndicator = UIActivityIndicatorView.alloc.initWithFrame(CGRectMake(0, 0, 30, 20))
    activityIndicator.startAnimating

    btn = UIBarButtonItem.alloc.initWithCustomView(activityIndicator)
    self.setToolbarItems(arrayWithObjects:"btn", animated:true)
    self.navigationItem.leftBarButtonItem = btn
    self.performSelector("eventActivityIndicator", withObject:nil, afterDelay:0.1)
  end
end
