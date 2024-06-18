import SwiftUI

struct TrackListItem: View {
    private typealias Str = Rsc.TrackListItem

    enum Style {
        case normal
        case shared
    }

    let style: Style
    let dateFormatter: DateFormatter
    let formatter: DateComponentsFormatter
    var track: TrackedPath
    let shareAction: (_ trackedPath: TrackedPath) -> Void
    let closeAction: () -> Void
    let updateAction: (_ trackedPath: TrackedPath, _ shared: Bool) -> Void
    let noteAction: (_ note: String, _ trackedPath: TrackedPath) -> Void
    let deleteAction: (_ trackedPath: TrackedPath) -> Void
    let totalDistance: Double
    let openedInitially: Bool
    var startDate: Date
    var endDate: Date
    var date: String
    @State var isOpened = false
    @State var note = ""
    @State var name = ""
    @State var isShowingOnMap = true
    @State private var showingAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingRenameAlert = false

    var body: some View {
        VStack(spacing: .zero) {
            header
                .padding(.bottom, .su8)
            if isOpened || openedInitially {
                openedSection
            }
        }
        .padding(.su8)
        .background(.white)
        .cornerRadius(.su20)
        .padding(.su8)
        .customShadow()
    }

    var header: some View {
        HStack {
            Text(track.name)
                .textStyle(.bodyLargeBold)
            Spacer()
            VStack(alignment: .trailing) {
                Text(Str.Header.date)
                    .textStyle(.bodySmall)
                Text(track.startDate)
                    .textStyle(.bodyBold)
            }
            if openedInitially {
                Button {
                    withAnimation {
                        closeAction()
                    }
                } label: {
                    Image(systemName: "arrowtriangle.down")
                        .foregroundColor(.softWhite)
                        .frame(width: .su40, height: .su40)
                        .background(Color.blueSecondary)
                        .cornerRadius(.su20)
                }
            } else {
                Button {
                    withAnimation {
                        isOpened.toggle()
                    }
                } label: {
                    Image(systemName: isOpened ? "xmark" : "arrowtriangle.down")
                        .foregroundColor(isOpened ? .softWhite : .darkSlateGray)
                        .frame(width: .su40, height: .su40)
                        .rotationEffect(isOpened ? .degrees(180) : .zero)
                        .background(Color.blueSecondary)
                        .cornerRadius(.su20)
                }
            }
        }
        .alert(Str.Alert.Rename.title, isPresented: $showingRenameAlert) {
            TextField(Str.Alert.Rename.textField, text: $name)
                .autocorrectionDisabled(true)
            Button(Str.Alert.Rename.button) {
                var newTrack = track
                newTrack.name = name
                updateAction(newTrack, false)
                name = ""
                showingRenameAlert.toggle()
            }
            Button(
                Str.Alert.Rename.cancelButton,
                role: .cancel
            ) {
                name = ""
                showingRenameAlert.toggle()
            }
        }
        .alert(Str.Alert.Note.title, isPresented: $showingAlert) {
            TextField(Str.Alert.Note.textField, text: $note)
                .autocorrectionDisabled(true)
            Button(Str.Alert.Note.button) {
                noteAction(note, track)
                note = ""
                showingAlert.toggle()
            }
            Button(
                Str.Alert.Note.cancelButton,
                role: .cancel
            ) {
                note = ""
                showingAlert.toggle()
            }
        }
        .alert(Str.Alert.Delete.title, isPresented: $showingDeleteAlert) {
            Button(
                Str.Alert.Delete.button,
                role: .destructive
            ) {
                deleteAction(self.track)
                showingDeleteAlert.toggle()
            }
            Button(
                Str.Alert.Delete.cancelButton,
                role: .cancel
            ) {
                showingDeleteAlert.toggle()
            }
        }
    }

    var openedSection: some View {
        VStack(spacing: .zero) {
            Divider()
                .padding(.vertical, .su8)
            HStack {
                Text("Total distance moved:")
                    .textStyle(.body)
                Spacer()
                Text("\(totalDistance, specifier: "%.f") meters")
                    .textStyle(.bodyBold)
            }
            .padding(.bottom, .su4)
            HStack {
                Text("Duration:")
                    .textStyle(.body)
                Spacer()
                Text("\(date)")
                    .textStyle(.bodyBold)
            }
            .padding(.bottom, .su8)
            HStack {
                Text("Show on Map")
                    .textStyle(.body)
                Spacer()
                Toggle(isOn: $isShowingOnMap) {
                }
                .toggleStyle(SwitchToggleStyle(tint: .blueSecondary))
            }
            normalSection
        }
        .onChange(of: isShowingOnMap) { _, newValue in
            var newTrack = track
            newTrack.tracking = newValue
            updateAction(newTrack, style == .shared)
        }
        .onAppear {
            self.isShowingOnMap = track.tracking
        }
    }

    var normalSection: some View {
        VStack(spacing: .zero) {
            Divider()
                .padding(.vertical, .su8)
            if !openedInitially {
                notesSection
            }
            HStack {
                if !openedInitially && style == .normal {
                    Button {
                        shareAction(track)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .fixedSize()
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                    Spacer()
                }
                if style == .normal {
                    Button("Rename") {
                        name = track.name
                        showingRenameAlert.toggle()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
                Spacer()
                Button("Delete") {
                    showingDeleteAlert.toggle()
                }
                .buttonStyle(SkiingButtonStyle(style: .borderedRed))
            }.padding(.su8)
        }
    }
    var notesSection: some View {
        Group {
            HStack {
                Text("Notes")
                    .textStyle(.bodySmall)
                    .padding(.bottom, .su8)
                Spacer()
                if style == .normal {
                    Button("Add note") {
                        showingAlert.toggle()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .bordered))
                }
            }
            LazyVStack {
                ForEach(track.notes ?? [], id: \.self) { note in
                    HStack {
                        Text(note)
                            .textStyle(.bodySmallBold)
                        Spacer()
                    }
                }
            }
            Divider()
                .padding(.vertical, .su8)
        }
    }

    init(
        track: TrackedPath,
        style: Style = .normal,
        shareAction: @escaping (_ trackedPath: TrackedPath) -> Void = { _ in },
        closeAction: @escaping () -> Void = {},
        updateAction: @escaping (_ trackedPath: TrackedPath, _ shared: Bool) -> Void = { _, _ in },
        noteAction: @escaping (_ note: String, _ trackedPath: TrackedPath) -> Void = { _, _ in },
        deleteAction: @escaping (_ trackedPath: TrackedPath) -> Void = { _ in },
        totalDistance: Double,
        isOpened: Bool = false,
        note: String = "",
        name: String = "",
        showingAlert: Bool = false,
        showingRenameAlert: Bool = false
    ) {
        self.track = track
        self.style = style
        self.shareAction = shareAction
        self.closeAction = closeAction
        self.updateAction = updateAction
        self.noteAction = noteAction
        self.deleteAction = deleteAction
        self.totalDistance = totalDistance
        self.openedInitially = isOpened
        self.startDate = Date()
        self.endDate = Date()
        self.date = ""
        self.dateFormatter = DateFormatter()
        self.formatter = DateComponentsFormatter()
        self.isOpened.toggle()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        self.note = note
        self.name = name
        self.showingAlert = showingAlert
        self.showingRenameAlert = showingRenameAlert
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.startDate = dateFormatter.date(from: track.startDate) ?? Date()
        self.endDate = dateFormatter.date(from: track.endDate) ?? Date()
        self.date = formatter.string(from: startDate.distance(to: endDate)) ?? ""
    }
}

struct TrackListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(
            track: .init(
                id: "ID123",
                name: "Path 123123",
                startDate: "2023-05-21 11:15:55",
                endDate: "2023-05-21 12:19:52",
                notes: ["Note1 description something", "Note2 description something"],
                tracking: true
            ),
            updateAction: { _, _ in
            }, noteAction: { _, _  in
            }, deleteAction: { _ in
            },
            totalDistance: 1_000
        )
    }
}
